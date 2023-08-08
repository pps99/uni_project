<template>
  <div>
    <Notifications style="margin-top:60px;" />
    <div class="d-flex align-items-center justify-content-center" style="height: 100vh;">
      <div class="card w-50 m-auto shadow">
        <div class="card-body">
          <h3 class="my-3 col-lg-6 col-12 m-auto">Update Account</h3>
          <form class="col-lg-6 col-12 m-auto" @submit.prevent="update">
            <div class="form-group mt-4">
              <label>Name</label>
              <input type="text" class="form-control" v-model="user.name" >
              <div v-if="errorMessage">
                  <span class="text-danger" v-for="error in errors.name" :key="error"> Name {{ error }}</span>
                </div>
            </div>
            <div class="form-group">
              <label>Email address</label>
              <input type="text" class="form-control" v-model="user.email">
              <div v-if="errorMessage">
                  <span class="text-danger" v-for="error in errors.email" :key="error"> Email {{ error }}</span>
                </div>
            </div>
            <div class="form-group mt-4">
              <a href="javascript:void(0)" data-toggle="modal" data-target="#staticBackdrop">Change Password</a>
            </div>
            <div class="form-group mt-4">
              <label>Phone No</label>
              <input type="text" class="form-control" v-model="user.phone">
              <div v-if="errorMessage">
                  <span class="text-danger" v-for="error in errors.phone" :key="error"> Phone {{ error }}</span>
                </div>
            </div>
            <div class="form-group mt-4">
              <label>Address</label>
              <input type="text" class="form-control" v-model="user.address">
              <div v-if="errorMessage">
                  <span class="text-danger" v-for="error in errors.address" :key="error"> Address {{ error }}</span>
                </div>
            </div>
            <div class="clearfix">
                <button @click="back" class="float-left btn btn-outline-dark">back</button>
                <button type="submit" class="float-right btn btn-outline-primary">submit</button>
            </div>
          </form>

          <!-- Modal -->
          <div class="modal fade" id="staticBackdrop" data-backdrop="static" data-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
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
                      <button type="button" class="btn btn-outline-secondary rounded-pill" data-dismiss="modal" @click="close">Close</button>
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
        console.log(error.response.data)
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
      console.log(response)
      this.user = response.data.user
    })
  }
  
}
</script>
<style>
  .hidden {
    display: none;
  }
</style>