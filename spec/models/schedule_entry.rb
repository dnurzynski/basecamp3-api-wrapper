require 'spec_helper'

describe 'ScheduleEntry Model' do
  include RequestHelpers
  include JSONFixtures

  before(:each) do
    @fixtures_object = 'schedule_entry.json'
    @fixtures_collection = 'schedule_entries.json'

    @bucket_id = '12345'
    @parent_id = '12345'
    @id = '12345'

    establish_connection
  end

  it 'returns a list of schedule entries' do
    stub_http_request(:get, "/buckets/#{@bucket_id}/schedules/#{@parent_id}/entries", @fixtures_collection)

    schedule_entries = Basecamp3::ScheduleEntry.all(@bucket_id, @parent_id)
    expected_schedule_entries = json_to_model(@fixtures_collection, Basecamp3::ScheduleEntry)

    expect(schedule_entries.count).to be(expected_schedule_entries.count)
    expect(schedule_entries).to all be_instance_of(Basecamp3::ScheduleEntry)
    expect(schedule_entries.map{ |t| t.id }).to match_array(expected_schedule_entries.map{ |t| t.id })
  end

  it 'returns a specific schedule entry' do
    stub_http_request(:get, "/buckets/#{@bucket_id}/schedule_entries/#{@id}", @fixtures_object)

    schedule_entry = Basecamp3::ScheduleEntry.find(@bucket_id, @id)
    expected_schedule_entry = json_to_model(@fixtures_object, Basecamp3::ScheduleEntry)

    expect(schedule_entry).to be_instance_of Basecamp3::ScheduleEntry
    expect(schedule_entry.id).to eq(expected_schedule_entry.id)
  end

  it 'creates a schedule entry' do
    stub_http_request(:post, "/buckets/#{@bucket_id}/schedules/#{@parent_id}/entries", @fixtures_object)

    schedule_entry = Basecamp3::ScheduleEntry.create(@bucket_id, @parent_id, {
      summary: 'test', starts_at: Time.now.to_i, 'ends_at': Time.now.to_i
    })

    expect(schedule_entry).to be_instance_of(Basecamp3::ScheduleEntry)
  end

  it 'should raise StandardError for missing required fields when creates a schedule entry' do
    stub_http_request(:post, "/buckets/#{@bucket_id}/schedules/#{@parent_id}/entries", @fixtures_object)

    expect{ Basecamp3::ScheduleEntry.create(@bucket_id, @parent_id, { }) }.to raise_error(StandardError)
  end

  it 'updates a schedule entry' do
    stub_http_request(:put, "/buckets/#{@bucket_id}/schedule_entries/#{@id}", @fixtures_object)

    schedule_entry = Basecamp3::ScheduleEntry.update(@bucket_id, @id, {
      summary: 'test', starts_at: Time.now.to_i, 'ends_at': Time.now.to_i
    })

    expect(schedule_entry).to be_instance_of(Basecamp3::ScheduleEntry)
  end

  it 'should raise StandardError for missing required fields when updates a schedule entry' do
    stub_http_request(:put, "/buckets/#{@bucket_id}/schedule_entries/#{@id}", @fixtures_object)

    expect{ Basecamp3::ScheduleEntry.update(@bucket_id, @id, { }) }.to raise_error(StandardError)
  end

  it 'deletes a schedule entry' do
    stub_http_request(:put, "/buckets/#{@bucket_id}/recordings/#{@id}/status/trashed", nil, { status: 204 })

    response = Basecamp3::ScheduleEntry.delete(@bucket_id, @id)

    expect(response).to be true
  end
end