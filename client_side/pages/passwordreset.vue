<template>
    <div>
      <div v-if="errors.error_res" class="d-flex align-items-center justify-content-center" style="height: 100vh;">
              <div class="card w-50 m-auto shadow">
                <div class="card-body">
                  <h5 class="card-title text-danger display-4"> {{ errors.error_res }}</h5>
                  <p class="card-text">Please Reset Your Password Again</p>
                  <NuxtLink to="/forgetpassword" class="btn btn-primary">Reset Password</NuxtLink>
                </div>
              </div>
            </div>
      <div v-else class="d-flex align-items-center justify-content-center" style="height: 100vh;">
        <div class="card w-50 m-auto shadow">
          <div class="card-body">
            <h3 class="my-3 col-lg-6 col-12 m-auto">Reset Your Password</h3>
            <form @submit.prevent="save_reset_password" class="col-lg-6 col-12 m-auto">
              <div class="form-group mt-4">
                <label>Password</label>
                <div class="position-relative">
                  <input :type="type" class="form-control" v-model="user.password">
                  <font-awesome-icon :icon="icon" class="mr-2 font-awesome position-absolute" @click="showPwd" style="right: 2px;top: 12px;color:#7b8ea1;" v-show="user.password" />
                </div>
              </div>
              <div class="form-group">
                <label>Confirm Password</label>
                <div class="position-relative">
                  <input :type="c_type" class="form-control" v-model="user.password_confirmation">
                  <font-awesome-icon :icon="c_icon" class="mr-2 font-awesome position-absolute" @click="showcPwd" style="right: 2px;top: 12px;color:#7b8ea1;" v-show="user.password_confirmation" />
                </div>
                <div v-if="errorMessage">
                    <span class="text-danger" v-for="error in errors.password_confirmation" :key="error"> Password Confirmation {{ error }}</span>
                  </div>
              </div>                
              <button type="submit" class="float-right btn btn-outline-primary">submit</button>   
            </form>
          </div>
        </div>
      </div>

    </div>
  </template>
  
  <script>
  export default {
    auth: 'guest',
    data(){
      return {
         user:{
           password : '',
           password_confirmation : '',
           email : this.$route.query.useremail,
           token : this.$route.query.token
         },
        errors: {},
        errorMessage: false,
        type: 'password',
        c_type: 'password',
        icon: 'eye',
        c_icon: 'eye'
      }
    },
    methods: {
      save_reset_password(){
        this.$axios.post(`/password/reset_save`,this.user)
        .then(response => {
          this.$notify({
            title: 'Success',
            text: 'Login successful'
          });
          this.$router.push('/login')
          this.errorMessage = false
        })
        .catch(error => {
          this.$notify({
            title: 'Fail',
            text: 'Something went wrong. Please try again',
            type: 'error'
          });
          this.errors = error.response.data.error
          this.errorMessage = true
        })
        
      },
      showPwd(){
        if(this.type === 'password'){
          this.type = 'text'
          this.icon = 'eye-slash'
        }else {
          this.type = 'password'
          this.icon = 'eye'
        }
      },
      showcPwd(){
        if(this.c_type === 'password'){
          this.c_type = 'text'
          this.c_icon = 'eye-slash'
        }else {
          this.c_type = 'password'
          this.c_icon = 'eye'
        }
      }
    }
  }
  </script>
  