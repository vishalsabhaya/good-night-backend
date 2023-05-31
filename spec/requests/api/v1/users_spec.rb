require 'rails_helper'

RSpec.describe 'Api::V1::Users', type: :request do
  let(:current_user) { create(:user) }
  let(:following_user) { create(:user) }

  describe 'POST #follow' do
    context 'with valid parameters' do
      it 'when following to another user' do
        post api_v1_user_follow_path(current_user.id, following_user.id), as: :json
        expect(response).to have_http_status(:ok)
        expect(Following.count).to eq(1)
      end
    end

    context 'with invalid parameters' do
      it 'when Following User not found' do
        post api_v1_user_follow_path(current_user.id, 0), as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_json).to eq({ "errors"=>[I18n.t("error.E0002")] })
      end

      it 'when You can not follow your self' do
        post api_v1_user_follow_path(current_user.id, current_user.id), as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_json).to eq({ "errors"=>[I18n.t("error.E0005")] })
      end

      it 'when You already following to user' do
        post api_v1_user_follow_path(current_user.id, following_user.id), as: :json
        expect(response).to have_http_status(:ok)
        expect(Following.count).to eq(1)

        post api_v1_user_follow_path(current_user.id, following_user.id), as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_json).to eq({ "errors"=>[I18n.t("error.E0003",p0:following_user.name)] })
      end

    end
  end

  describe 'DELETE #unfollow' do
    let!(:following) { create(:following, user: current_user, following_user: following_user) }

    context 'with valid parameters' do
      it 'when destroys the user friendship' do
        delete api_v1_user_unfollow_path(current_user.id, following_user.id), as: :json
        expect(response).to have_http_status(:ok)
        expect(Following.count).to eq(0)
      end
    end

    context 'with invalid parameters' do
      it 'when Following User not found' do
        delete api_v1_user_unfollow_path(current_user.id, 0), as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_json).to eq({ "errors"=>[I18n.t("error.E0002")] })
      end
    end
  end
end
