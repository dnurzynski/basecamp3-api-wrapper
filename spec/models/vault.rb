require 'spec_helper'

describe 'Vault Model' do
  include RequestHelpers
  include JSONFixtures

  before(:each) do
    @fixtures_object = 'vault.json'
    @fixtures_collection = 'vaults.json'

    @bucket_id = '12345'
    @parent_id = '12345'
    @id = '12345'

    establish_connection
  end

  it 'returns a list of vaults' do
    stub_http_request(:get, "/buckets/#{@bucket_id}/vaults/#{@parent_id}/vaults", @fixtures_collection)

    vaults = Basecamp3::Vault.all(@bucket_id, @parent_id)
    expected_vaults = json_to_model(@fixtures_collection, Basecamp3::Vault)

    expect(vaults.count).to be(expected_vaults.count)
    expect(vaults).to all be_instance_of(Basecamp3::Vault)
    expect(vaults.map{ |t| t.id }).to match_array(expected_vaults.map{ |t| t.id })
  end

  it 'returns a specific vault' do
    stub_http_request(:get, "/buckets/#{@bucket_id}/vaults/#{@id}", @fixtures_object)

    todo = Basecamp3::Vault.find(@bucket_id, @id)
    expected_todo = json_to_model(@fixtures_object, Basecamp3::Vault)

    expect(todo).to be_instance_of Basecamp3::Vault
    expect(todo.id).to eq(expected_todo.id)
  end

  it 'creates a vault' do
    stub_http_request(:post, "/buckets/#{@bucket_id}/vaults/#{@parent_id}/vaults", @fixtures_object)

    todo = Basecamp3::Vault.create(@bucket_id, @parent_id, { title: 'test' })

    expect(todo).to be_instance_of(Basecamp3::Vault)
  end

  it 'should raise StandardError for missing required fields when creates a vault' do
    stub_http_request(:post, "/buckets/#{@bucket_id}/vaults/#{@parent_id}/vaults", @fixtures_object)

    expect{ Basecamp3::Vault.create(@bucket_id, @parent_id, { }) }.to raise_error(StandardError)
  end

  it 'updates a vault' do
    stub_http_request(:put, "/buckets/#{@bucket_id}/vaults/#{@id}", @fixtures_object)

    todo = Basecamp3::Vault.update(@bucket_id, @id, { title: 'test' })

    expect(todo).to be_instance_of(Basecamp3::Vault)
  end

  it 'should raise StandardError for missing required fields when updates a vault' do
    stub_http_request(:put, "/buckets/#{@bucket_id}/vaults/#{@id}", @fixtures_object)

    expect{ Basecamp3::Vault.update(@bucket_id, @id, { }) }.to raise_error(StandardError)
  end
end