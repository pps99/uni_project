<template>
  <div class="profileupdate-container">
    <div class="d-flex align-items-center justify-content-center" style="height: 100vh;">
      <div class="card profileupdate-card shadow">
        <div class="card-body">
          <h3 class="card-title text-center">Update Account</h3>
          <form class="profileupdate-form" @submit.prevent="update">
            <div class="form-group mt-4">
              <label for="name">Name</label>
              <input type="text" class="form-control reduced-opacity-input" id="name" v-model="user.name">
              <div v-if="errorMessage">
                <span class="text-danger" v-for="error in errors.name" :key="error"> Name {{ error }}</span>
              </div>
            </div>
            <div class="form-group">
              <label for="email">Email address</label>
              <input type="text" class="form-control reduced-opacity-input" id="email" v-model="user.email">
              <div v-if="errorMessage">
                <span class="text-danger" v-for="error in errors.email" :key="error"> Email {{ error }}</span>
              </div>
            </div>
            <div class="form-group mt-4">
              <a href="#" data-toggle="modal" data-target="#staticBackdrop" class="white">Change Password</a>
            </div>
            <div class="form-group">
              <label for="phone">Phone No</label>
              <input type="text" class="form-control reduced-opacity-input" id="phone" v-model="user.phone">
              <div v-if="errorMessage">
                <span class="text-danger" v-for="error in errors.phone" :key="error"> Phone {{ error }}</span>
              </div>
            </div>
            <div class="form-group">
              <label for="address">Address</label>
              <input type="text" class="form-control reduced-opacity-input" id="address" v-model="user.address">
              <div v-if="errorMessage">
                <span class="text-danger" v-for="error in errors.address" :key="error"> Address {{ error }}</span>
              </div>
            </div>
            <div class="clearfix">
              <button @click="back" class="float-left btn btn-dark">Back</button>
              <button type="submit" class="float-right btn btn-primary">Submit</button>
            </div>
          </form>

          <!-- Modal -->
          <div class="modal fade modal-reduced-opacity" id="staticBackdrop" data-backdrop="static" data-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
              <div class="modal-content">
                <div class="modal-header">
                  <h5 class="modal-title" id="staticBackdropLabel">Change Password</h5>
                  <button type="button" class="close" data-dismiss="modal" aria-label="Close" @click="close">
                    <span aria-hidden="true">&times;</span>
                  </button>
                </div>
                <div class="modal-body">
                  <form action="" @submit.prevent="changePass">
                    <div class="form-group">
                      <label>Old Password</label>
                      <input type="password" class="form-control" placeholder="Old Password" v-model="passwords.old_pass">
                      <div v-if="errorMessage">
                        <span class="text-danger"> {{ errors.error }}</span>
                      </div>
                    </div>
                    <div class="form-group">
                      <label>Password</label>
                      <input type="password" class="form-control" placeholder="New Password" v-model="passwords.password">
                      <div v-if="errorMessage">
                        <span class="text-danger" v-for="error in errors.password" :key="error"> Password {{ error }}</span>
                      </div>
                    </div>
                    <div class="form-group">
                      <label>Confirm Password</label>
                      <input type="password" class="form-control" placeholder="Confirm Password" v-model="passwords.password_confirmation">
                      <div v-if="errorMessage">
                        <span class="text-danger" v-for="error in errors.password_confirmation" :key="error"> Password Confirmation {{ error }}</span>
                      </div>
                    </div>
                    <div class="d-flex justify-content-between">
                      <button type="button" class="btn btn-secondary rounded-pill" data-dismiss="modal" @click="close">Close</button>
                      <button class="btn btn-primary rounded-pill" :disabled="!passwords.old_pass" id="change">Change</button>
                    </div>
                  </form>
                </div>
                
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      user: {
        name: '',
        email: '',
        password: '',
        password_confirmation: '',
        phone: '',
        address: ''
      },
      passwords: {
        old_pass: '',
        password: '',
        password_confirmation: '',
      },
      errors: [],
      errorMessage: false,
      showModal: false
    }
  },
  methods: {
    update(){
      this.$axios.put(`/users/${this.user.id}`, this.user)
      .then(response => {
        this.errorMessage = false
        this.$notify({
          title: 'Success',
          text: 'Successfully Updated'
        });
        this.$router.push('/')
      })
      .catch(error => {
        this.errors = error.response.data
        this.errorMessage = true
        this.$notify({
          title: 'Fail',
          text: 'Something went wrong. Please try again',
          type: 'error'
        });
      })
    },
    changePass(){
      this.$axios.post('/users/change_password', this.passwords)
        .then(response => {
          this.$router.push('/sub_pages/profile_update')
          this.close()
          $('#staticBackdrop').modal('hide');
          this.errorMessage = false
          this.$notify({
            title: 'Success',
            text: 'Password changed successfully'
          })
        })
        .catch(error => {
          this.errorMessage = true
          this.errors = error.response.data
          this.$notify({
            title: 'Fail',
            text: 'Something went wrong. Please try again',
            type: 'warn'
          })
        })
    },
    close(){
        this.passwords.old_pass = this.passwords.password = this.passwords.password_confirmation = ''
        this.errorMessage = false
    },
    back(){
      this.$router.back()
    }
  },

  mounted() {
    this.$axios.get(`/user`)
    .then(response => {
      this.user = response.data.user
    })
  }
  
}
</script>
<style>
  .hidden {
    display: none;
  }
  .profileupdate-container {
    height: 100vh;
    background-image: url('~/assets/backery_index_img.jpg');
    background-size: cover;
    background-position: center;
    background-repeat: no-repeat;
    overflow-y: scroll;
  }

  .profileupdate-form {
  padding: 20px;
}

.profileupdate-card {
  width: 500px;
  background-color: rgba(255, 255, 255, 0.5);
  border-radius: 25px;
}


.reduced-opacity-input {
  opacity: 0.6; /* Adjust the opacity value as needed */
}
.modal-reduced-opacity {
  opacity: 0.9; /* Adjust the opacity value as needed */
}

.modal-content{
  border-radius: 25px;
  width: 485px;
}
.white{
  color: white;
}
</style>