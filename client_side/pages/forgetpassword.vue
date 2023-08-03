<template>
    <div>
      <div class="d-flex align-items-center justify-content-center" style="height: 100vh;">
        <div class="card w-50 m-auto shadow">
          <div class="card-body">
            <h3 class="my-3 col-lg-6 col-12 m-auto">Reset Password</h3>
            <form @submit.prevent="reset_password" class="col-lg-6 col-12 m-auto">
              <div class="form-group mt-5">
                <label>Email address</label>
                <input type="email" class="form-control" v-model="user.email">
                <div v-if="errorMessage">
                    <span class="text-danger"> {{ errors.error_res }}</span>
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
    auth: false,
    data(){
      return {
         user:{
           email : ''
         },
        errors: {},
        errorMessage: false
      }
    },
    methods: {
      reset_password(){
        this.$axios.post(`/password/reset?email=${this.user.email}`)
        .then(response => {
          this.errorMessage = false
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
      back(){
        this.$router.back()
      }
    }
  }
  </script>
  