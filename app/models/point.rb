class Point < ApplicationRecord
  belongs_to :user
  before_create :checkPointsBeforeCreate
  before_update :checkPointsBeforeUpdate
  after_save :updateNetworkPoints, :levelGraduation

  def total_points
    (self.value || 0) + (self.networking_points || 0)
  end

  private

  def checkPointsBeforeCreate
    if self.value && self.value > 0
      @networkPoints = self.value
    end
  end

  def checkPointsBeforeUpdate
    if self.value_was != self.value
      @networkPoints = self.value - self.value_was
    end
  end

  def updateNetworkPoints
    if @networkPoints && self.user.host
      job = UpdatePointsNetworkingJob.new(self.user.host, @networkPoints)
      job.run()
    end
    @networkPoints = nil
  end

  def levelGraduation
    job = UserGraduationJob.new(self.user, self.total_points)
    job.run()
  end
end
