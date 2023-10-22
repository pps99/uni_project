<template>
  <div class="notification-container">
    <div
      v-for="notification in notifications"
      :key="notification.id"
      class="alert alert-dismissible fade show notification-item"
      @click="handleNotificationClick(notification.message.message)"
    >
      {{ notification.message.message }}
      <button @click="removeNotification(notification.id)" class="close-button close">
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
    removeNotification(id) {
      // Remove the notification with the given ID from the notifications array
      this.$emit('remove-notification', id);
    },
    handleNotificationClick(message) {
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
