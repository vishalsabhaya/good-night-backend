RSpec.describe UserFollowing do
  let(:following_user) { create(:user) }
  let(:current_user) { create(:user) }
  let(:options) { { following_user_id: following_user.id, current_user: current_user } }
  let(:user_following) { UserFollowing.new(options) }
  let(:response) { user_following.instance_variable_get(:@response) }

  describe '#follow' do
    context 'when following user exists' do
      context 'when not already following' do
        it 'follows the user' do
          expect(user_following.follow).to eq(response)
          expect(response.is_success).to be true
          expect(response.message).to eq(I18n.t('info.I0001', p0: following_user.name))
          expect(response.errors).to be_empty
        end
      end

      context 'when already following' do
        it 'does not follow the user' do
          existing_following = create(:following, user: current_user, following_user: following_user)
          expect(user_following.follow).to eq(response)
          expect(response.is_success).to be false
          expect(response.message).to be_nil
          expect(response.errors).to eq([I18n.t('error.E0003', p0: following_user.name)])
        end
      end

      context 'when attempting to follow oneself' do
        it 'does not follow oneself' do
          options[:following_user_id] = current_user.id

          expect(user_following.follow).to eq(response)
          expect(response.is_success).to be false
          expect(response.message).to be_nil
          expect(response.errors).to eq([I18n.t('error.E0005')])
        end
      end
    end

    context 'when following user does not exist' do
      before do
        options[:following_user_id] = -1 # non-existent user id
      end

      it 'returns empty response' do
        expect(user_following.follow).to eq(response)
        expect(response.is_success).to be false
        expect(response.message).to be_nil
        expect(response.errors).to eq([I18n.t('error.E0002')])
      end
    end
  end

  describe '#unfollow' do
    context 'when following user exists' do
      context 'when already following' do
        it 'unfollows the user' do
          existing_following = create(:following, user: current_user, following_user: following_user)
          expect(current_user.follower).to receive(:find_by).with(following_user_id: following_user.id).and_return(existing_following)
          expect(existing_following).to receive(:destroy)

          expect(user_following.unfollow).to eq(response)
          expect(response.is_success).to be true
          expect(response.message).to eq(I18n.t('info.I0002', p0: following_user.name))
          expect(response.errors).to be_empty
        end
      end

      context 'when not already following' do
        it 'does not unfollow the user' do
          expect(user_following.unfollow).to eq(response)
          expect(response.is_success).to be false
          expect(response.message).to be_nil
          expect(response.errors).to eq([I18n.t('error.E0004', p0: following_user.name)])
        end
      end
    end

    context 'when following user does not exist' do
      before do
        options[:following_user_id] = -1 # non-existent user id
      end

      it 'returns empty response' do
        expect(user_following.unfollow).to eq(response)
        expect(response.is_success).to be false
        expect(response.message).to be_nil
        expect(response.errors).to eq([I18n.t('error.E0002')])
      end
    end
  end
end