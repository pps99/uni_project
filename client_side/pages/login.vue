<template>
  <div class="login-container d-flex align-items-center justify-content-end">
    <div class="card login-card shadow">
      <div class="card-body">
        <h3 class="card-title text-center mb-4">Cake Shop Login</h3>
        <form @submit.prevent="login" class="login-form">
          <div class="form-group">
            <label for="email">Email address</label>
            <input type="email" class="form-control reduced-opacity-input" id="email" v-model="user.email" required>
          </div>
          <div class="form-group">
            <label for="password">Password</label>
            <input type="password" class="form-control reduced-opacity-input" id="password" v-model="user.password" required>
            <div v-if="errorMessage" class="mt-2">
              <span class="text-danger">{{ errors }}</span>
            </div>
          </div>
          <div class="d-flex justify-content-between align-items-center">
            <NuxtLink to="/forgetpassword" class="text-muted">Forgot Password?</NuxtLink>
            <NuxtLink to="/register" class="btn btn-link">Create an account</NuxtLink>
          </div>
          <button type="submit" class="btn btn-primary btn-block mt-3">Login</button>
        </form>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      user: {
        email: '',
        password: '',
      },
      errors: {},
      errorMessage: false,
    };
  },
  methods: {
    async login() {
      try {
        await this.$auth.loginWith('local', { data: this.user });
        this.$notify({
          title: 'Success',
          text: 'Login successful',
        });
        this.$router.push('/');
        this.errorMessage = false;
      } catch (error) {
        this.$notify({
          title: 'Fail',
          text: 'Something went wrong. Please try again',
          type: 'error',
        });
        this.errors = error.response.data.error;
        this.errorMessage = true;
      }
    },
  },
};
</script>


<style scoped>
.login-container {
  height: 100vh;
  background-image: url('../assets/backery_img.jpg');
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  padding-right: 20%;
}

.login-card {
  width: 400px;
  background-color: rgba(255, 255, 255, 0.5);
  border-radius: 25px;
}

.login-form {
  padding: 20px;
}

.btn-link {
  text-decoration: none;
  color: #FF6B6B;
}

.btn-link:hover {
  text-decoration: underline;
}

@media (max-width: 576px) {
  .login-card {
    width: 100%;
  }
}

.reduced-opacity-input {
  opacity: 0.6; /* Adjust the opacity value as needed */
}
</style>
