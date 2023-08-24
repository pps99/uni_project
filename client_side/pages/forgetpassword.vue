<template>
      <div class="forgetpassword-container d-flex align-items-center justify-content-end">
        <div class="card forgetpassword-card shadow">
          <div class="card-body">
            <h3 class="card-title text-center mb-4">Reset Password</h3>
            <form @submit.prevent="reset_password" class="forgetpassword-form">
              <div class="form-group">
                <label>Email address</label>
                <input type="email" class="form-control reduced-opacity-input" v-model="user.email">
                <div v-if="errorMessage">
                    <span class="text-danger"> {{ errors.error_res }}</span>
                </div>
              </div>
              <div class="clearfix">
                  <button @click="back" class="float-left btn btn-dark">back</button>
                  <button type="submit" class="float-right btn btn-primary">submit</button>
              </div>

            </form>
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
            text: 'forgetpassword successful'
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
<style scoped>
  .forgetpassword-container {
    height: 100vh;
    background-image: url('../assets/backery_img.jpg');
    background-size: cover;
    background-position: center;
    background-repeat: no-repeat;
    padding-right: 20%;
  }

  .forgetpassword-form {
  padding: 20px;
}

.forgetpassword-card {
  width: 400px;
  background-color: rgba(255, 255, 255, 0.5);
  border-radius: 25px;
}


.reduced-opacity-input {
  opacity: 0.6; /* Adjust the opacity value as needed */
}

</style> 