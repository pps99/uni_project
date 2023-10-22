<template>
  <div class="notification-container">
    <div
      v-for="(notification, index) in notifications"
      :key="index"
      class="alert alert-dismissible fade show notification-item"
      @click="handleNotificationClick(notification.message,index)"
    >
      {{ index }} - {{ notification.message }}
      <button @click="removeNotification(index)" class="close-button close">
        <span>&times;</span>
      </button>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    notifications: Array,
  },
  methods: {
    removeNotification(index) {
      // Remove the notification at the specified index from the notifications array
      console.log(this.notifications[index]);
      this.notifications.splice(index, 1);
    },
    handleNotificationClick(message,index) {
      this.$axios.post(`/notifications/read?id=${this.notifications[index].id}`)
        .then(response => {
          console.log("Successful");
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
      if (message === 'recharge_amount') {
        // Use the Vue Router to navigate to the desired route
        this.$router.push('/sub_pages/confirm_recharge_amount');
      }else if( message == 'order_request'){
        this.$router.push('/sub_pages/confirm_orders');
      }
      // Add more conditions for other messages and routes if needed
    },
  },
};
</script>

<style scoped>
.notification-container {
  position: fixed;
  bottom: 20px;
  right: 20px;
  z-index: 1000;
  max-height: 250px; /* Adjust the max-height as needed */
  overflow-y: auto; /* Enable vertical scrolling */
}

.notification-item {
  margin-bottom: 10px;
  background-color: #ffffff;
}

.close-button {
  background: none;
  border: none;
  cursor: pointer;
  font-size: 18px;
  color: #ff0000;
  padding: 0;
}

/* You can add custom styles for notifications here */
</style>
