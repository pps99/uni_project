<template>
  <div class="d-flex align-items-center justify-content-center rechargebalance-container" style="height: 100vh;">
    <div class="card rechargebalance-card shadow">
      <div class="card-body" style="text-decoration-color: white;">
        <h3 class="card-title text-center mb-4">Recharge Amount</h3>
        <div class="d-flex align-items-center justify-content-center ">
          <img class="text-center modify_image" src="~/assets/kpay_image.jpg" width="300px" height="300px"/>
        </div>
        <form @submit.prevent="confirm_transition" class="login-form">
          <div class="form-group">
            <label>Recharge Amount</label>
            <input type="text" class="form-control reduced-opacity-input" id="recharge_amount" v-model="recharge_amount" required>
          </div>
          <div class="form-group">
            <label>Transition No</label>
            <input type="text" class="form-control reduced-opacity-input" id="transition_no"  pattern="^[0-9]{20}$" v-model="transition_no" required>
            <small class="form-text text-muted">Enter 20 numeric values.</small>
          </div>
          <button type="submit" class="btn btn-primary btn-block mt-3">Submit</button>
          <button class="btn btn-secondary btn-block mt-3" @click="back">Back</button>
        </form>
      </div>
    </div>
  </div>
</template>
<script>
export default{
    data() {
        return{
          recharge_amount: '',
          transition_no: '',
        }
    },
    methods: {
      confirm_transition() {
        this.$axios.post(`/savetransition_no?recharge_amount=${this.recharge_amount}&transition_no=${this.transition_no}&user_id=${this.$auth.user.user.id}`)
        .then(response => {
          this.errorMessage = false
          this.$notify({
            title: 'Success',
            text: 'Successfully created'
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
      back(){
        this.$router.back();
      },
    },
    mounted() {
    },
}
</script>
<style scoped>

  .rechargebalance-container {
    background-image: url('~/assets/backery_index_img.jpg');
    background-size: cover;
    background-position: center;
    background-repeat: no-repeat;
  }

  .rechargebalance-card {
    width: 500px;
    background-color: rgba(255, 255, 255, 0.5);
    border-radius: 25px;
  }

  .modify_image {
    border-radius: 25px;
  }
</style>