require 'spec_helper'

class Address < Hashie::IUTrash
  property :street, from: 'Street'
  property :number, from: 'Number'
end

class Person < Hashie::IUTrash
  property :name, from: 'Name'
  property :phone, from: 'Telephone'
  property :main_address, from: 'MainAddress', with: ->(values) { Address.new(values) }
end

describe Hashie::IUTrash do
  let(:params) { { 'Name' => 'foo', 'Telephone' => 123, 'MainAddress' => { 'Street' => 'Rua 1', 'Number' => 123 } } }

  subject(:person) { Person.new(params) }

  it 'translates parameters according to declared on class' do
    expect(person.name).to eq('foo')
    expect(person.phone).to eq(123)
    expect(person.main_address.street).to eq('Rua 1')
    expect(person.main_address.number).to eq(123)
  end

  it 'ignores undeclared parameters' do
    expect(Person.new('Weight' => 65)).to be_an_instance_of(Person)
  end

  describe '#inverse_attributes' do
    it 'returns a hash with their properties using inverse translated' do
      expect(person.inverse_attributes).to eq(params)
    end
  end
end
