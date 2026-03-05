const fs = require('fs');
const TwitterApi = require('twitter-api-v2').default;

const threadPath = process.argv[2];
if (!threadPath) {
  console.error('Usage: node post_tweet_oauth2.js <thread.jsonl>');
  process.exit(1);
}

const thread = fs.readFileSync(threadPath, 'utf8').trim().split('\n').map(line => JSON.parse(line));

const keys = JSON.parse(fs.readFileSync('/Users/matthew/ClawEmpire/secrets/x-api.json'));
const client = new TwitterApi({
  appKey: keys.consumer_key,
  appSecret: keys.consumer_secret,
  accessToken: keys.access_token,
  accessSecret: keys.access_token_secret,
});

async function postThread() {
  const firstTweet = await client.v2.tweet(thread[0].text);
  let prevId = firstTweet.data.id;
  for (let i = 1; i < thread.length; i++) {
    const tweet = await client.v2.tweet(thread[i].text, { reply: { in_reply_to_tweet_id: prevId } });
    prevId = tweet.data.id;
  }
  console.log('Thread posted. First ID:', firstTweet.data.id);
}

postThread().catch(console.error);
