class Team < ApplicationRecord
  has_many :goals, dependent: :destroy

  validates :name, presence: true
  validates :order, presence: true, uniqueness: true

  enum entity: { orders: 0, sales: 1 }

  scope :prev_team, -> (order) { where('"order" < ?', order).order(:order).last }
  scope :next_team, -> (order) { where('"order" > ?', order).order(:order).first }

  def self.has_prev_team?(order)
    exists?(['"order" < ?', order])
  end

  def self.has_next_team?(order)
    exists?(['"order" > ?', order])
  end

  def current_month_goal?
    goals.order(:date).last.date.month == Date.current.month if goals
  end
end
