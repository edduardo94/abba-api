class Level < ApplicationRecord
    has_many :users, inverse_of: :level

    scope :by_points, ->(points) {
        order(points: :desc)
            .where("points <= :points and active = :active", {
                :points => points,
                :active => 1
            })
            .limit(1)
    }
end
