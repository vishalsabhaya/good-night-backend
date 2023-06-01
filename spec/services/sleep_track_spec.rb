RSpec.describe SleepTrack do
  let(:current_user) { create(:user) }
  let(:options) { { current_user: current_user } }
  let(:sleep_track) { SleepTrack.new(options) }
  let(:response) { sleep_track.instance_variable_get(:@response) }

  describe '#index' do
    let!(:following_user1) { create(:user) }
    let!(:following_user2) { create(:user) }
    let!(:sleep_tracking1) do
      create(:sleep_tracking, user: following_user1, clock_in: 1.day.ago, clock_out: 1.day.ago + 8.hours)
    end
    let!(:sleep_tracking2) do
      create(:sleep_tracking, user: following_user2, clock_in: 2.day.ago, clock_out: 2.day.ago + 7.hours)
    end

    before do
      current_user.following_users << following_user1
      current_user.following_users << following_user2
    end

    it 'returns sleep records of all following users from the previous week, sorted by sleep duration' do
      expected_data = [
        {
          'id' => sleep_tracking1.id,
          'user_id' => following_user1.id,
          'name' => following_user1.name,
          'clock_in' => sleep_tracking1.clock_in,
          'clock_out' => sleep_tracking1.clock_out,
          'sleep_duration' => sleep_tracking1.sleep_duration
        },
        {
          'id' => sleep_tracking2.id,
          'user_id' => following_user2.id,
          'name' => following_user2.name,
          'clock_in' => sleep_tracking2.clock_in,
          'clock_out' => sleep_tracking2.clock_out,
          'sleep_duration' => sleep_tracking2.sleep_duration
        }
      ].as_json
      # Make the service call
      response = sleep_track.index
      expect(response.is_success).to be true
      # Assertion
      expect(response.data).to eq(expected_data)
      expect(response.errors).to be_empty
    end
  end

  describe '#clock_in' do
    context 'when no existing sleep record without clock out' do
      it 'creates a new sleep record with clock in time' do
        expect(sleep_track.clock_in).to eq(response)
        expect(response.is_success).to be true
        expect(response.message).to eq(I18n.t('info.I0003'))
        expect(response.data).to eq(current_user.sleep_trackings.where(clock_out:nil))
        expect(response.errors).to be_empty
      end
    end

    context 'when an existing sleep record without clock out exists' do
      it 'does not create a new sleep record' do
        existing_sleep_record = create(:sleep_tracking, user: current_user, clock_out: nil)
        expect(sleep_track.clock_in).to eq(response)
        expect(response.is_success).to be false
        expect(response.message).to be_nil
        expect(response.data).to be_nil
        expect(response.errors).to eq([I18n.t('error.E0006')])
      end
    end
  end

  describe '#clock_out' do
    context 'when an existing sleep record without clock out exists' do
      it 'updates the sleep record with clock out time and calculates sleep duration' do
        existing_sleep_record = create(:sleep_tracking, user: current_user, clock_out: nil)
        current_time = Time.zone.now

        expect(sleep_track.clock_out).to eq(response)
        expect(response.is_success).to be true
        expect(response.message).to eq(I18n.t('info.I0004'))
        expect(response.errors).to be_empty
      end
    end

    context 'when no existing sleep record without clock out' do
      it 'does not update any sleep record' do
        expect(current_user.sleep_trackings).to receive(:find_by).with(clock_out: nil).and_return(nil)
        expect(current_user.sleep_trackings).not_to receive(:update!)

        expect(sleep_track.clock_out).to eq(response)
        expect(response.is_success).to be false
        expect(response.message).to be_nil
        expect(response.errors).to eq([I18n.t('error.E0007')])
      end
    end
  end
end