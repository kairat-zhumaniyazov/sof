require "rails_helper"

RSpec.describe SubscribersMailer, type: :mailer do
  describe "new_answer_notification" do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question, user: create(:user)) }
    let(:mail) { SubscribersMailer.new_answer_notification(answer) }

    it "renders the headers" do
      expect(mail.subject).to eq("New answer notification")
      expect(mail.to).to eq([question.user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
