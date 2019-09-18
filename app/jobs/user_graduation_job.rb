class UserGraduationJob
    def initialize(user, points)
        @user = user
        @points = points
        @currentLevel = @user.level
    end

    def run
        @level = Level.by_points(@points).first
        if @level
            if @currentLevel
                if @currentLevel.points < @level.points
                    @user.update(level_id: @level.id)
                end
            else
                @user.update(level_id: @level.id)
            end
        end
    end
end