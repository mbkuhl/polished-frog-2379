require "rails_helper"

RSpec.describe Doctor, type: :feature do
  before :each do
    @hospital1 = Hospital.create!(name: "UC")
    @hospital2 = Hospital.create!(name: "UTMB")
    @doctor1 = @hospital1.doctors.create!(name: "Doctor 1", specialty: "Rheum", university: "LSU")
    @doctor2 = @hospital2.doctors.create!(name: "Doctor 2", specialty: "Gastro", university: "MSU")
    @doctor3 = @hospital2.doctors.create!(name: "Doctor 3", specialty: "Card", university: "KSU")
    @patient1 = @doctor1.patients.create!(name: "Patient 1", age: 10)
    @patient2 = @doctor1.patients.create!(name: "Patient 2", age: 20)
    @patient3 = @doctor2.patients.create!(name: "Patient 3", age: 50)
    @patient4 = @doctor1.patients.create!(name: "Patient 4", age: 40)
    @patient5 = @doctor2.patients.create!(name: "Patient 5", age: 30)
    @patient6 = @doctor3.patients.create!(name: "Patient 6", age: 70)
  end

  describe "As a visitor, when I visit a doctor's show page" do
    describe "I see all of the doctor's information including, name, specialty, and university where they got their doctorate" do
      it "And I see the name of the hospital where this doctor works, along with all of the patients this doctor has" do
        visit "/doctors/#{@doctor1.id}"
        expect(page).to have_content("Doctor 1")
        expect(page).to have_content("Specialty: Rheum")
        expect(page).to have_content("University: LSU")
        expect(page).to have_content("Hospital: UC")
        expect(page).to have_content("Patients:")
        expect(page).to have_content("Patient 1")
        expect(page).to have_content("Patient 2")
        expect(page).to have_content("Patient 4")
        expect(page).to_not have_content("Patient 3")
        expect(page).to_not have_content("Patient 5")
        expect(page).to_not have_content("Patient 6")

        visit "/doctors/#{@doctor2.id}"
        expect(page).to have_content("Doctor 2")
        expect(page).to have_content("Specialty: Gastro")
        expect(page).to have_content("University: MSU")
        expect(page).to have_content("Hospital: UTMB")
        expect(page).to have_content("Patients:")
        expect(page).to have_content("Patient 3")
        expect(page).to have_content("Patient 5")
        expect(page).to_not have_content("Patient 4")
        expect(page).to_not have_content("Patient 1")
        expect(page).to_not have_content("Patient 2")
        expect(page).to_not have_content("Patient 6")
      end
    end

    it "I see a button to remove a patient from that doctor's caseload. I click the button and am returned to the showpage where I do not see that patient. When I visit a different doctor's shw page that is caring for the patient, I stil see that patient" do
      @doctor4 = @hospital1.doctors.create!(name: "Doctor 4", specialty: "Card", university: "NSU")
      @doctor4.patients << @patient1
      @doctor4.patients << @patient2

      visit "/doctors/#{@doctor4.id}"
      expect(page).to have_content("Patient 1")
      visit "/doctors/#{@doctor1.id}"
      expect(page).to have_content("Patient 1")
      click_button("Remove Patient 1 from Doctor 1")
      expect(current_path).to eq("/doctors/#{@doctor1.id}")
      expect(page).to_not have_content("Patient 1")
      visit "/doctors/#{@doctor4.id}"
      expect(page).to have_content("Patient 1")
      click_button("Remove Patient 1 from Doctor 4")
      expect(current_path).to eq("/doctors/#{@doctor4.id}")
      expect(page).to_not have_content("Patient 1")

    end
  end

end