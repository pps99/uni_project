class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = UserService.getUserByID(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @is_user_create = UserService.createUser(@user)
    if @is_user_create
      token = encode_token({ user_id: @user.id })
      render json: { user: @user, token: token }, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def edit
    @user = UserService.getUserByID(params[:id])
  end

  def update
    @user = UserService.getUserByID(params[:id])
    @is_user_update = UserService.updateUser(@user, user_params)
    if @is_user_update
      redirect_to root_path
    else
      render :edit
    end
  end

  def destroy
    @user = UserService.getUserByID(params[:id])
    UserService.destroy(@user)
    redirect_to users_path
  end

  def validate_login
    @user = User.find_by(email: params[:email])
    if @user == nil
      render json: { error: 'Please Create the Account' }, status: :unprocessable_entity
    elsif @user.authenticate(params[:password])
      token = encode_token({user_id: @user.id})
      render json: { data: { user: @user, token: token } }
    elsif @user.password != params[:password]
      render json: { error: 'Email and Password Missmatched' }, status: :unprocessable_entity
    end
  end

  def auto_login
    render json: { user: @user }
  end

  def promote
    @user = UserService.getUserByID(params[:format])
    @sql = "update users set role='admin' where id =#{@user.id} ;"
    ActiveRecord::Base.connection.execute(@sql)
    redirect_to users_path
  end

  def degrade
    @user = UserService.getUserByID(params[:format])
    @sql = "update users set role='user' where id =#{@user.id} ;"
    ActiveRecord::Base.connection.execute(@sql)
    redirect_to users_path
  end

  

  def logout
    session[:user_id] = nil
    render json: { message: 'User was successfully logged out' }
  end

  private

  def user_params
    params.permit(:name, :email, :password, :password_confirmation)
  end
end
