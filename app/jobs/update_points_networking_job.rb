class UpdatePointsNetworkingJob
    def initialize(user, points)
        @user = user
        @points = points
    end

    def run
        if @user.point
            networking_points = (@user.point.networking_points || 0) + @points
            networking_points = 0 if networking_points < 0
            @user.point.update(networking_points: networking_points)
            puts "[Pontos de rede] User: #{@user.id} | Pontos: #{networking_points} | Movimentação: (#{@points}) pontos"
        else
            networking_points = @points
            networking_points = 0 if networking_points < 0

            point = Point.find_or_initialize_by(user_id: @user.id)
            point.value = point.value || 0
            point.networking_points = networking_points
            point.save()

            puts "[Pontos de rede] User: #{@user.id} | Pontos: #{networking_points} | Movimentação: (#{@points}) pontos"
        end

        if @user.host
            command = UpdatePointsNetworkingJob.new(@user.host, @points)
            command.run()
        end
    end
end