require 'rails_helper'

RSpec.describe Patient do
  describe "associations" do
    it {should have_many :doctors}
    it {should have_many(:doctors).through(:patient_doctors)}
    it {should have_many(:hospitals).through(:doctors)}
  end

  before :each do
    @hospital1 = Hospital.create!(name: "UC")
    @hospital2 = Hospital.create!(name: "UTMB")
    @doctor1 = @hospital1.doctors.create!(name: "Doctor 1", specialty: "Rheum", university: "LSU")
    @doctor2 = @hospital2.doctors.create!(name: "Doctor 2", specialty: "Gastro", university: "MSU")
    @doctor3 = @hospital2.doctors.create!(name: "Doctor 3", specialty: "Card", university: "KSU")
    @doctor4 = @hospital1.doctors.create!(name: "Doctor 4", specialty: "Card", university: "NSU")
    @patient1 = @doctor1.patients.create!(name: "bPatient 1", age: 10)
    @patient2 = @doctor1.patients.create!(name: "cPatient 2", age: 20)
    @patient3 = @doctor2.patients.create!(name: "kPatient 3", age: 50)
    @patient4 = @doctor1.patients.create!(name: "rPatient 4", age: 40)
    @patient5 = @doctor2.patients.create!(name: "mPatient 5", age: 18)
    @patient6 = @doctor3.patients.create!(name: "aPatient 6", age: 70)
  end

  describe "class methods" do
    it "#alphebetized adults" do
      expect(Patient.alphebetized_adults).to eq([@patient6, @patient2, @patient3, @patient4])
    end
  end
end