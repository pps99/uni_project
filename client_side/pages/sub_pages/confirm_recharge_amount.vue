<template>
<div class="rechargebalance-container">
  <div v-if="nothingtoshow" class="d-flex align-items-center justify-content-center" style="height: 100vh;">
    <button class="btn btn-info" style="color: black; background-color: white;" type="button" @click="goback()">Nothing To Show Go Back To Main Page</button>
  </div>
  <div v-else   style="height: 100vh;">
    <div class="card-container d-flex">
      <div
        v-for="recharge_item in recharge_items"
        :key="recharge_item.id"
        class="col-md-4 mb-4"
      >
        <div class="card custom-card reduced-opacity">
          <div class="card-body">
            <h5 class="card-title text-center card-title-custom">
              Recharge for {{ recharge_item['user_detail'].name }}
            </h5>
            <div class="user-details">
              <p class="card-text user-detail-text">
                <strong>Email:</strong> {{ recharge_item['user_detail'].email }}
              </p>
              <p class="card-text user-detail-text">
                <strong>Amount:</strong> MMK{{ recharge_item['transition'].recharge_amount }}
              </p>
              <p class="card-text user-detail-text">
                <strong>Transition No:</strong> {{ recharge_item['transition'].transition_no }}
              </p>
            </div>
            <button class="btn btn-dark" @click="goback()">Back</button>
            <button class="btn btn-primary custom-button" @click="updateAmount(recharge_item['transition'])">Confirm</button>
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
      recharge_items: [],
      nothingtoshow: false
    };
  },
  methods: {
    updateAmount(transition){
      this.$axios
        .post(`/transitions/updateAccountAmount?transition_id=${transition.id}`)
        .then((response) => {
          if( this.recharge_items.length === 0){
            this.nothingtoshow = true
          }
          window.location.reload();
        })
        .catch((error) => {
          this.$notify({
            title: 'Error',
            text: 'Something went wrong. Please try again',
            type: 'error',
          });
          console.error('Error fetching data:', error);
        });
      },
      cancelAmount(transition){
        this.$axios
          .post(`/transitions/cancelAccountAmount?transition_id=${transition.id}`)
          .then((response) => {
                      if( this.recharge_items.length === 0){
            this.nothingtoshow = true
          }
          window.location.reload();
          })
          .catch((error) => {
            this.$notify({
              title: 'Error',
              text: 'Something went wrong. Please try again',
              type: 'error',
            });
            console.error('Error fetching data:', error);
          });
      },
      goback() {
        this.$router.push('/');
      },
  },
  mounted() {
    this.$axios
      .get(`/transitions`)
      .then((response) => {
        this.recharge_items = response.data.recharge_items;
        if( this.recharge_items.length === 0){
            this.nothingtoshow = true
        }
      })
      .catch((error) => {
        this.$notify({
          title: 'Error',
          text: 'Something went wrong. Please try again',
          type: 'error',
        });
        console.error('Error fetching data:', error);
      });
  },

};
</script>

<style scoped>
.rechargebalance-container {
  background-image: url('~/assets/backery_index_img.jpg');
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  padding: 30px; /* Add some padding for spacing */
}

.card {
  border: none; /* Remove border from card */
  border-radius: 20px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  background-color: #f7f7f7;
}

.reduced-opacity {
  background-color: rgba(255, 255, 255, 0.7);
}
.custom-card {
  padding: 20px;
}

.card-title-custom {
  font-size: 22px;
  margin-bottom: 10px;
  color: #333;
}

.user-details {
  margin: 15px 0;
  border-top: 1px solid #ddd;
  padding-top: 10px;
}

.user-detail-text {
  margin: 5px 0;
  color: #555;
}

.custom-button {
  background-color: #ff9800;
  border: none;
  padding: 8px 20px;
  border-radius: 5px;
  color: #fff;
  font-weight: bold;
  transition: background-color 0.2s;
  cursor: pointer;
}

.custom-button:hover {
  background-color: #f57c00;
}
</style>
