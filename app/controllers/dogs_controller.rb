class DogsController < ApplicationController
  before_action :set_dog, only: [:show, :edit, :update, :destroy, :like]

  # GET /dogs
  # GET /dogs.json
  def index
    if params[:sort]
      @pagy, @dogs = pagy(Dog.order(likes: :desc), items: 5)
    else
      @pagy, @dogs = pagy(Dog.all, items: 5)
    end
  end

  # GET /dogs/1
  # GET /dogs/1.json
  def show
  end

  # GET /dogs/new
  def new
    @dog = Dog.new
  end

  # GET /dogs/1/edit
  def edit
    if @dog.user != current_user
      redirect_to @dog, notice: 'Only the owner can edit a dog!' 
    end
  end

  # POST /dogs
  # POST /dogs.json
  def create
    @dog = Dog.new(dog_params)

    @dog.user = current_user
    @dog.likes = 0

    respond_to do |format|
      if @dog.save
        @dog.images.attach(params[:dog][:image]) if params[:dog][:image].present?

        format.html { redirect_to @dog, notice: 'Dog was successfully created.' }
        format.json { render :show, status: :created, location: @dog }
      else
        format.html { render :new }
        format.json { render json: @dog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dogs/1
  # PATCH/PUT /dogs/1.json
  def update
    if @dog.user != current_user
      redirect_to @dog, notice: 'Only the owner can edit a dog!' 
    end

    respond_to do |format|
      if @dog.update(dog_params)
        @dog.images.attach(params[:dog][:image]) if params[:dog][:image].present?

        format.html { redirect_to @dog, notice: 'Dog was successfully updated.' }
        format.json { render :show, status: :ok, location: @dog }
      else
        format.html { render :edit }
        format.json { render json: @dog.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /dogs/1
  # POST /dogs/1.json
  def like
    if @dog.user != current_user
      @dog.likes += 1
      if @dog.save
        redirect_to @dog, notice: "You liked #{@dog.name}."
      else
       render :edit, notice: 'Something went wrong! Contact an Admin'
      end
    end
  end

  # DELETE /dogs/1
  # DELETE /dogs/1.json
  def destroy
    @dog.destroy
    respond_to do |format|
      format.html { redirect_to dogs_url, notice: 'Dog was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dog
      @dog = Dog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dog_params
      params.require(:dog).permit(:name, :description, :images)
    end
end
