<template>
    <div class="d-flex align-items-center justify-content-center" style="height: 100vh;">
      <div class="card w-50 m-auto shadow">
        <div class="card-body">
          <h3 class="my-3 text-center">Login</h3>
          <form @submit.prevent="login" class="col-lg-6 col-12 m-auto">
            <div class="form-group">
              <label>Email address</label>
              <input type="email" class="form-control" v-model="user.email">
            </div>
            <div class="form-group">
              <label>Password</label>
              <input type="password" class="form-control" v-model="user.password">
              <div v-if="errorMessage">
                  <span class="text-danger" >{{ errors }}</span>
                </div>
            </div>
            <NuxtLink to="/forgetpassword" class="text-align-left">Forget Password?</NuxtLink>
            <div class="clear-fix mt-3">
              <NuxtLink to="/register" class="float-left btn btn-outline-info">Create an account</NuxtLink>
              <button type="submit" class="float-right btn btn-outline-primary">Login</button>         
            </div>          
          </form>


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
           email : '',
            password: '',
         },
        errors: {},
        errorMessage: false
      }
    },
    methods: {
      async login(){
        await this.$auth.loginWith('local', { data: this.user })
        .then(response => {
          this.$notify({
            title: 'Success',
            text: 'Login successful'
          });
          this.$router.push('/')
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
  
    }
  }
  </script>
  