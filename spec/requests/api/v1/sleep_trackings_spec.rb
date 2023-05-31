# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::SleepTrackings', type: :request do
  let(:current_user) { create(:user) }

  def sleep_duration_hour(sleep_duration)
    "#{(sleep_duration / 3600).to_i}:#{(sleep_duration % 3600 / 60).to_i}:#{sleep_duration % 60}"
  end

  describe 'POST #clock_in' do
    context 'check in successful' do
      it 'clocks in the user' do
        post clock_in_api_v1_user_sleep_trackings_path(current_user.id), as: :json
        expect(response).to have_http_status(:ok)
        expect(current_user.sleep_trackings.count).to eq(1)
      end
    end

    context 'clocks in without clock out' do
      before { create(:sleep_tracking, user: current_user, clock_in: Time.zone.now, clock_out: nil) }

      it 'clocks in again without clock out' do
        post clock_in_api_v1_user_sleep_trackings_path(current_user.id), as: :json
        expected_response = { "errors"=>[I18n.t("error.E0006")] }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_json).to eq(expected_response)
      end
    end
  end
  describe 'PATCH #clock_out' do
    context 'check in successful' do
      before { create(:sleep_tracking, user: current_user, clock_in: Time.zone.now, clock_out: nil) }

      it 'clocks in the user' do
        patch clock_out_api_v1_user_sleep_trackings_path(current_user.id), as: :json
        expect(response).to have_http_status(:ok)
        expect(current_user.sleep_trackings.last.clock_out).to be_present
      end
    end

    context 'clocks out without clock in' do
      it 'clocks out again without clock in' do
        patch clock_out_api_v1_user_sleep_trackings_path(current_user.id), as: :json
        expected_response = { "errors"=>[I18n.t("error.E0007")] }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_json).to eq(response_json)
      end
    end
  end

end
