require 'rails_helper'

describe Space do
  describe "instance methods" do
    let(:attacked_space) { create(:space ) }
    let(:hit_space) { create(:space, status: "Hit") }
    describe "#not_attacked?" do
    end
  end
end
