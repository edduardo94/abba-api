class BonusNetworkingJob
    def initialize(user, spentAmount, commissionDistributed = 0)
        @user = user
        @spentAmount = spentAmount
        @commissionDistributed = commissionDistributed
        @level = @user.level
    end

    def run
        if isGraduated()
            percentage = commissionPercentage()
            
            if percentage > 0
                amount = @spentAmount * (percentage / 100)
                puts "[Bonus de rede] User: #{@user.id} #{levelDescription()} | Dist. acum.: #{@commissionDistributed}% | Comissão: R$ #{amount} (#{percentage}%)"
                @commissionDistributed = @commissionDistributed + percentage
                puts "[Bonus de rede] Dist. acum. para próximo nível: #{@commissionDistributed}"
                commission = (@user.commission.value || 0) + amount
                @user.commission.update(value: commission)
            end
        end

        if @user.host and @commissionDistributed < 20
            job = BonusNetworkingJob.new(@user.host, @spentAmount, @commissionDistributed)
            job.run()
        else
            puts "[Bonus de rede] User: #{@user.id} #{levelDescription()} | Dist. acum: #{@commissionDistributed} | DISTRIBUICAO ENCERRADA"
        end
    end

    def isGraduated
        @user.activated? && (@level ? true : false)
    end

    def commissionPercentage
        percentage = (@level.commission || 0) - @commissionDistributed
        return 0 if percentage <=0
        percentage
    end

    def levelDescription
        return "(#{@level.title} #{@level.commission}%)" if isGraduated()
        return "(Usuário não graduado)"
    end
end