RSpec.describe SleepTrack do
  let(:current_user) { create(:user) }
  let(:options) { { current_user: current_user } }
  let(:sleep_track) { SleepTrack.new(options) }
  let(:response) { sleep_track.instance_variable_get(:@response) }

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