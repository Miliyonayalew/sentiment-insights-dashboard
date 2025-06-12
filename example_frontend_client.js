// Example JavaScript client code to connect to ActionCable
// This would be used in your frontend application (React, Vue, etc.)

class MentionsClient {
  constructor(jwtToken) {
    this.token = jwtToken;
    this.cable = null;
    this.subscription = null;
  }

  connect() {
    // Connect to ActionCable with JWT token in URL params
    this.cable = ActionCable.createConsumer(
      `ws://localhost:3000/cable?token=${this.token}`
    );

    this.subscription = this.cable.subscriptions.create("MentionsChannel", {
      connected() {
        console.log("Connected to MentionsChannel");
      },

      disconnected() {
        console.log("Disconnected from MentionsChannel");
      },

      received(data) {
        console.log("Received data:", data);

        switch (data.type) {
          case "fetch_started":
            this.handleFetchStarted(data);
            break;
          case "mentions_fetched":
            this.handleMentionsFetched(data);
            break;
          case "fetch_error":
            this.handleFetchError(data);
            break;
        }
      },

      handleFetchStarted(data) {
        console.log(`Started fetching mentions for keyword: ${data.keyword}`);
        // Update UI to show loading state
        document.getElementById(
          `keyword-${data.keyword_id}-status`
        ).textContent = "Fetching...";
      },

      handleMentionsFetched(data) {
        console.log(
          `Fetched ${data.new_mentions_count} new mentions for: ${data.keyword}`
        );

        // Update UI with new mentions
        const mentionsContainer = document.getElementById(
          `keyword-${data.keyword_id}-mentions`
        );

        data.mentions.forEach((mention) => {
          const mentionElement = document.createElement("div");
          mentionElement.innerHTML = `
            <h4>${mention.title}</h4>
            <p>${mention.content}</p>
            <small>Source: ${mention.source} | Sentiment: ${mention.sentiment}</small>
            <a href="${mention.url}" target="_blank">Read more</a>
          `;
          mentionsContainer.appendChild(mentionElement);
        });

        // Update status
        document.getElementById(
          `keyword-${data.keyword_id}-status`
        ).textContent = `Completed! Found ${data.new_mentions_count} new mentions`;
      },

      handleFetchError(data) {
        console.error(`Error fetching mentions: ${data.error}`);
        document.getElementById(
          `keyword-${data.keyword_id}-status`
        ).textContent = `Error: ${data.error}`;
      },
    });
  }

  disconnect() {
    if (this.subscription) {
      this.subscription.unsubscribe();
    }
    if (this.cable) {
      this.cable.disconnect();
    }
  }

  // Method to trigger mention fetching
  async fetchMentions(keywordId) {
    try {
      const response = await fetch(
        `/api/v1/tracked_keywords/${keywordId}/fetch_mentions`,
        {
          method: "POST",
          headers: {
            Authorization: `Bearer ${this.token}`,
            "Content-Type": "application/json",
          },
        }
      );

      const result = await response.json();
      console.log("Fetch job started:", result);

      return result;
    } catch (error) {
      console.error("Error starting fetch job:", error);
      throw error;
    }
  }

  // Method to get current mentions
  async getMentions(keywordId) {
    try {
      const response = await fetch(
        `/api/v1/tracked_keywords/${keywordId}/mentions`,
        {
          headers: {
            Authorization: `Bearer ${this.token}`,
            "Content-Type": "application/json",
          },
        }
      );

      return await response.json();
    } catch (error) {
      console.error("Error fetching mentions:", error);
      throw error;
    }
  }

  // Method to get keyword status
  async getStatus(keywordId) {
    try {
      const response = await fetch(
        `/api/v1/tracked_keywords/${keywordId}/status`,
        {
          headers: {
            Authorization: `Bearer ${this.token}`,
            "Content-Type": "application/json",
          },
        }
      );

      return await response.json();
    } catch (error) {
      console.error("Error fetching status:", error);
      throw error;
    }
  }
}

// Usage example:
// const mentionsClient = new MentionsClient(yourJwtToken);
// mentionsClient.connect();

// To fetch mentions for a keyword:
// mentionsClient.fetchMentions(keywordId);

// The client will automatically receive real-time updates via WebSocket
