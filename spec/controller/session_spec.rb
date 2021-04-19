require 'rails_helper'

RSpec.describe SessionController, type: :controller do
  describe "GET new" do
    context 'user logged in' do
      it "redirect http success" do
        session[:user_id] = 1
        get :new
        expect(response).to redirect_to(timesheets_path)
      end
    end

    context 'user not logged in' do
      it "renders the index template" do
        get :new
        expect(response).to render_template(:new)
      end
    end
  end

  describe "POST create" do
    context 'user is valid' do
      before do
        @user = User.create email: 'example@mail.com', password: 'chicken'
        post :create, params: { email: 'example@mail.com', password: 'chicken' }
      end

      it 'validates and authenticates user' do
        expect(assigns(:user).present?).to eq(true)
        expect(assigns(:user).authenticate('chicken')).equal?(@user)
      end

      it 'redirects to index path' do
        expect(response).to redirect_to(timesheets_path)
      end
    end

    context 'user email is invalid' do
      before do
        @user = User.create email: 'example@mail.com', password: 'chicken'
        post :create, params: { email: 'unregistered@mail.com', password: 'chicken' }
      end

      it 'validates user email' do
        expect(assigns(:user).present?).to eq(false)
      end

      it 'redirects to login path' do
        expect(flash[:error]).to include('Invalid Email or Password.')
      end

      it 'redirects to index path' do
        expect(response).to redirect_to(login_path)
      end
    end

    context 'user password is invalid' do
      before do
        @user = User.create email: 'example@mail.com', password: 'chicken'
        post :create, params: { email: 'example@mail.com', password: 'drumsticks' }
      end

      it 'validates and authenticates user' do
        expect(assigns(:user).authenticate('drumsticks')).equal?(@user)
      end

      it 'redirects to login path' do
        expect(flash[:error]).to include('Invalid Email or Password.')
      end

      it 'redirects to index path' do
        expect(response).to redirect_to(login_path)
      end
    end

  end

  describe "GET destroy" do
    it "logout a user" do
      session[:user_id] = 1
      get :destroy
      expect(session[:user_id].nil?).to eq(true)
      expect(response).to redirect_to(login_path)
    end
  end

end
