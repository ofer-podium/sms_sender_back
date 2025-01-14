# SMS Sender - Backend

## Overview

The backend for the SMS Sender project is built using **Ruby on Rails** and serves as the core processing engine. It manages SMS requests, tracks message delivery statuses using Twilio, and communicates real-time updates to the frontend through PubNub.

---

## Key Features

- **Send SMS Messages**:
  - Handles SMS requests from the frontend and sends messages using Twilio's API.
- **Track Message Status**:
  - Monitors delivery statuses (e.g., “Sent”, “Delivered”, “Failed”) via Twilio webhooks.
  - Pushes real-time updates to the frontend using PubNub.
- **Scalable and Secure**:
  - Designed to handle high message volumes efficiently.
  - Ensures secure communication with authenticated and encrypted API endpoints.

---

## Technologies Used

- **Framework**: Ruby on Rails
- **SMS Service**: Twilio
- **Real-Time Communication**: PubNub
- **Database**: Amazon RDS (MySql)
- **Testing**: RSpec
