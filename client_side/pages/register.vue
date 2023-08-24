<template>
    <div class="register-container d-flex align-items-center justify-content-end">
      <div class="card register-card shadow">
        <div class="card-body">
          <h3 class="card-title text-center">Create An Account</h3>
          <form class="register-form" @submit.prevent="register">
            <div class="form-group">
              <label>Name</label>
              <input type="text" class="form-control reduced-opacity-input" v-model="user.name">
              <div v-if="errorMessage">
                  <span class="text-danger" v-for="error in errors.name" :key="error"> Name {{ error }}</span>
                </div>
            </div>
            <div class="form-group">
              <label>Email address</label>
              <input type="text" class="form-control reduced-opacity-input" v-model="user.email">
              <div v-if="errorMessage">
                  <span class="text-danger" v-for="error in errors.email" :key="error"> Email {{ error }}</span>
                </div>
            </div>
            <div class="form-group">
              <label>Password</label>
              <div class="position-relative">
                <input :type="type" class="form-control reduced-opacity-input" v-model="user.password">
                <font-awesome-icon :icon="icon" class="mr-2 font-awesome position-absolute" @click="showPwd" style="right: 2px;top: 12px;color:#7b8ea1;" v-show="user.password" />
              </div>
              <div v-if="errorMessage">
                  <span class="text-danger" v-for="error in errors.password" :key="error"> Password {{ error }}</span>
                </div>
            </div>
            <div class="form-group">
              <label>Confirm Password</label>
              <div class="position-relative">
                <input :type="c_type" class="form-control reduced-opacity-input" v-model="user.password_confirmation">
                <font-awesome-icon :icon="c_icon" class="mr-2 font-awesome position-absolute" @click="showcPwd" style="right: 2px;top: 12px;color:#7b8ea1;" v-show="user.password_confirmation" />
              </div>
              <div v-if="errorMessage">
                  <span class="text-danger" v-for="error in errors.password_confirmation" :key="error"> Password Confirmation {{ error }}</span>
                </div>
            </div>
            <div class="form-group">
              <label>Phone No</label>
              <input type="text" class="form-control reduced-opacity-input" v-model="user.phone">
              <div v-if="errorMessage">
                  <span class="text-danger" v-for="error in errors.phone" :key="error"> Phone {{ error }}</span>
                </div>
            </div>
            <div class="form-group">
              <label>Address</label>
              <input type="text" class="form-control reduced-opacity-input" v-model="user.address">
              <div v-if="errorMessage">
                  <span class="text-danger" v-for="error in errors.address" :key="error"> Address {{ error }}</span>
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
    auth: 'guest',
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
  <style scoped>
  .register-container {
    height: 100vh;
    background-image: url('../assets/backery_img.jpg');
    background-size: cover;
    background-position: center;
    background-repeat: no-repeat;
    padding-right: 15%;
    overflow-y: scroll;
  }

  .register-form {
  padding: 20px;
}

.register-card {
  width: 600px;
  background-color: rgba(255, 255, 255, 0.5);
  border-radius: 25px;
}


.reduced-opacity-input {
  opacity: 0.6; /* Adjust the opacity value as needed */
}

</style>