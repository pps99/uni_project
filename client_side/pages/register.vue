<template>
    <div>
      <div class="d-flex align-items-center justify-content-center" style="height: 100vh;">
        <div class="card w-50 m-auto shadow">
          <div class="card-body">
            <h3 class="my-3 col-lg-6 col-12 m-auto">Create An Account</h3>
            <form class="col-lg-6 col-12 m-auto" @submit.prevent="register">
              <div class="form-group mt-4">
                <label>Name</label>
                <input type="text" class="form-control" v-model="user.name">
                <div v-if="errorMessage">
                    <span class="text-danger" v-for="error in errors.name" :key="error"> Name {{ error }}</span>
                  </div>
              </div>
              <div class="form-group">
                <label>Email address</label>
                <input type="email" class="form-control" v-model="user.email">
                <div v-if="errorMessage">
                    <span class="text-danger" v-for="error in errors.email" :key="error"> Email {{ error }}</span>
                  </div>
              </div>
              <div class="form-group">
                <label>Password</label>
                <div class="position-relative">
                  <input :type="type" class="form-control" v-model="user.password">
                  <font-awesome-icon :icon="icon" class="mr-2 font-awesome position-absolute" @click="showPwd" style="right: 2px;top: 12px;color:#7b8ea1;" v-show="user.password" />
                </div>
                <div v-if="errorMessage">
                    <span class="text-danger" v-for="error in errors.password" :key="error"> Password {{ error }}</span>
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
              <div class="clearfix">
                  <button @click="back" class="float-left btn btn-outline-dark">back</button>
                  <button type="submit" class="float-right btn btn-outline-primary">submit</button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
  </template>
  
  <script>
  export default {
    auth: 'guest',
    data() {
      return {
        user: {
          name: '',
          email: '',
          password: '',
          password_confirmation: ''
        },
        errors: [],
        errorMessage: false,
        type: 'password',
        c_type: 'password',
        icon: 'eye',
        c_icon: 'eye'
      }
    },
    methods: {
      register(){
        this.$axios.post('/users', this.user)
        .then(response => {
          this.errorMessage = false
          this.$notify({
            title: 'Success',
            text: 'Successfully created'
          });
          this.$router.push('/login')
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
      },
      back(){
        this.$router.back()
      }
    }
    
  }
  </script>
  