require 'spec_helper'
require 'pry-rails'

class UserForUnique < TestModel
  attr_accessor :reservations

  def set_reservations(params)
    self.reservations = params.map{|h| Reservation.new(h)}
  end
end

class UserForUnique01 < UserForUnique
  validates :reservations,
            nested_attributes_uniqueness: {
              fields: [:reserved_at]
            }
end

class UserForUnique02 < UserForUnique
  validates :reservations,
            nested_attributes_uniqueness: {
              fields: [:reserved_at],
              ignore_nil: true
            }
end

class UserForUnique03 < UserForUnique
  validates :reservations,
            nested_attributes_uniqueness: {
              fields: [:reserved_date, :reserved_time],
              display_field: :reserved_at
            }
end

class UserForUnique04 < UserForUnique
  validates :reservations,
            nested_attributes_uniqueness: {
              fields: [:reserved_date, :reserved_time],
              display_field: :reserved_at,
              ignore_nil: true
            }
end


class Reservation < TestModel
  attr_accessor :reserved_at, :reserved_date, :reserved_time
end

describe 'NestedAttributesUniquenessValidator' do
  context 'valid with default settings' do
    param_groups =
      [
        [
          {reserved_at: DateTime.new(2016, 1, 1, 10, 0)},
          {reserved_at: DateTime.new(2016, 1, 2, 10, 0)},
          {reserved_at: DateTime.new(2016, 1, 3, 10, 0)},
        ],
        [
          {reserved_at: DateTime.new(2016, 1, 1, 10, 0)},
          {reserved_at: DateTime.new(2016, 1, 2, 10, 0)},
          {reserved_at: DateTime.new(2016, 1, 3, 10, 0)},
          {reserved_at: nil},
        ],
      ]
    param_groups.each do |params|
      user = UserForUnique01.new
      user.set_reservations(params)
      params_str = params.map{|h| h[:reserved_at].nil? ? "nil" : h[:reserved_at].to_s}
      it "#{params_str} should be valid" do
        expect(user).to be_valid
      end
    end
  end

  context 'invalid with default settings' do
    param_groups =
      [
        [
          {reserved_at: DateTime.new(2016, 1, 1, 10, 0)},
          {reserved_at: DateTime.new(2016, 1, 1, 10, 0)},
          {reserved_at: DateTime.new(2016, 1, 3, 10, 0)},
        ],
        [
          {reserved_at: DateTime.new(2016, 1, 1, 10, 0)},
          {reserved_at: DateTime.new(2016, 1, 2, 10, 0)},
          {reserved_at: nil},
          {reserved_at: nil},
        ],
      ]
    param_groups.each do |params|
      user = UserForUnique01.new
      user.set_reservations(params)
      params_str = params.map{|h| h[:reserved_at].nil? ? "nil" : h[:reserved_at].to_s}
      it "#{params_str} should be invalid" do
        expect(user).not_to be_valid
        expect(user.errors.messages.keys).to eq [:"reservations.reserved_at"]
      end
    end
  end

  context 'valid with ignore_nil' do
    param_groups =
      [
        [
          {reserved_at: DateTime.new(2016, 1, 1, 10, 0)},
          {reserved_at: DateTime.new(2016, 1, 2, 10, 0)},
          {reserved_at: nil},
          {reserved_at: nil},
        ],
      ]
    param_groups.each do |params|
      user = UserForUnique02.new
      user.set_reservations(params)
      params_str = params.map{|h| h[:reserved_at].nil? ? "nil" : h[:reserved_at].to_s}
      it "#{params_str} should be valid" do
        expect(user).to be_valid
      end
    end
  end

  context 'invalid with ignore_nil' do
    param_groups =
      [
        [
          {reserved_at: DateTime.new(2016, 1, 1, 10, 0)},
          {reserved_at: DateTime.new(2016, 1, 1, 10, 0)},
          {reserved_at: DateTime.new(2016, 1, 3, 10, 0)},
          {reserved_at: nil},
        ],
      ]
    param_groups.each do |params|
      user = UserForUnique02.new
      user.set_reservations(params)
      params_str = params.map{|h| h[:reserved_at].nil? ? "nil" : h[:reserved_at].to_s}
      it "#{params_str} should be invalid" do
        expect(user).not_to be_valid
        expect(user.errors.messages.keys).to eq [:"reservations.reserved_at"]
      end
    end
  end

  context 'valid with multiple fields' do
    param_groups =
      [
        [
          {reserved_date: "2016-01-01", reserved_time: "10:00"},
          {reserved_date: "2016-02-01", reserved_time: "10:00"},
          {reserved_date: "2016-03-01", reserved_time: "10:00"},
        ],
        [
          {reserved_date: "2016-01-01", reserved_time: "10:00"},
          {reserved_date: "2016-02-01", reserved_time: "10:00"},
          {reserved_date: nil,          reserved_time: nil},
        ],
      ]
    param_groups.each do |params|
      user = UserForUnique03.new
      user.set_reservations(params)
      it "#{params.to_s} should be valid" do
        expect(user).to be_valid
      end
    end
  end

  context 'invalid with multiple fields' do
    param_groups =
      [
        [
          {reserved_date: "2016-01-01", reserved_time: "10:00"},
          {reserved_date: "2016-01-01", reserved_time: "10:00"},
          {reserved_date: "2016-03-01", reserved_time: "10:00"},
        ],
        [
          {reserved_date: "2016-01-01", reserved_time: "10:00"},
          {reserved_date: "2016-02-01", reserved_time: "10:00"},
          {reserved_date: nil,          reserved_time: nil},
          {reserved_date: nil,          reserved_time: nil},
        ],
      ]
    param_groups.each do |params|
      user = UserForUnique03.new
      user.set_reservations(params)
      it "#{params.to_s} should be invalid" do
        expect(user).not_to be_valid
        expect(user.errors.messages.keys).to eq [:"reservations.reserved_at"]
        user.reservations.each do |reservation|
          if reservation.errors.messages.present?
            expect(reservation.errors.messages.keys).to eq [:reserved_date, :reserved_time]
          end
        end
      end
    end
  end

  context 'valid with ignore_nil, multiple fields' do
    param_groups =
      [
        [
          {reserved_date: "2016-01-01", reserved_time: "10:00"},
          {reserved_date: "2016-02-01", reserved_time: "10:00"},
          {reserved_date: nil,          reserved_time: nil},
          {reserved_date: nil,          reserved_time: nil},
        ],
      ]
    param_groups.each do |params|
      user = UserForUnique04.new
      user.set_reservations(params)
      it "#{params.to_s} should be valid" do
        expect(user).to be_valid
      end
    end
  end

  context 'invalid with ignore_nil, multiple fields' do
    param_groups =
      [
        [
          {reserved_date: "2016-01-01", reserved_time: "10:00"},
          {reserved_date: "2016-01-01", reserved_time: "10:00"},
          {reserved_date: "2016-03-01", reserved_time: "10:00"},
          {reserved_date: nil,          reserved_time: nil},
        ],
      ]
    param_groups.each do |params|
      user = UserForUnique04.new
      user.set_reservations(params)
      it "#{params.to_s} should be invalid" do
        expect(user).not_to be_valid
        expect(user.errors.messages.keys).to eq [:"reservations.reserved_at"]
        user.reservations.each do |reservation|
          if reservation.errors.messages.present?
            expect(reservation.errors.messages.keys).to eq [:reserved_date, :reserved_time]
          end
        end
      end
    end
  end
end
