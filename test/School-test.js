const {expect} = require('chai');
const {ethers} = require('hardhat');
const provider = ethers.provider;



describe("School Test" , function(){

    let student;
    let teacher;
    let School,school;

    
    before(async function(){
        [owner,student,teacher,manager] = await ethers.getSigners();
        School =  await ethers.getContractFactory("SchoolContract");
        school = await School.connect(owner).deploy();
       
        school.connect(owner).sendEtherStudent(student.address,ethers.utils.parseUnits("50",18));
        school.connect(student).getStudents(school.address,ethers.constants.MaxUint256);

    }); 

    it("Deploys The Contract", async function(){
        expect(school.address).to.be.properAddress;
    });

    describe("Contract Functions", function(){
     
         it("Student should see the notes" ,async function(){
            await school.connect(student).getStudents(student.address);
         });

         it("Teacher can add teacher?" ,async function(){
            await expect(school.connect(teacher).addTeacher(teacher.address)).to.be.reverted;
         });

         it("StudentspassedOrNot?", async function(){
            await school.connect(student).passedOrNot(student.address);
         });

         it("Can the manager add students?" ,async function(){
            await expect(school.connect(manager).addStudent()).to.not.be.equal(0);
         });
         it("Add Teacher", async function(){
            await expect(school.connect(manager).addTeacher(teacher.address));
         });
         
    })

});