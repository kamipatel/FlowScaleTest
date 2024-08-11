const jsforce = require('jsforce');

const s = 'b2';

const conn = new jsforce.Connection({
    oauth2: {
      clientId: '',
      clientSecret: '',
      redirectUri: 'https://localhost:8001/oauth/callback',
    },
  });


 // Function to handle insertion in batches
 async function insertInBatches(records, batchSize) {
  for (let i = 0; i < records.length; i += batchSize) {
      const batch = records.slice(i, i + batchSize);
      try {
          const result = await conn.sobject('Contact').create(batch);
          console.log('Batch insert result:', result);
      } catch (error) {
          console.error('Error inserting batch:', error);
      }
  }
}

const createContacts = async () => {

    console.log('createContacts called');

    try {
        const dummyContacts = [];  // Array to store promises
        for (let i = 1; i <= 10000; i++) {
            const contact = {
                FirstName: `Test${i}`,
                LastName: `User${i}`,
                Email: `flowscaletest+${i}@kam.test${s}`
            };
            //contacts.push(conn.sobject('Contact').create(contact));
            dummyContacts.push(contact);
        }
        // Wait for all promises to resolve (all contacts created)

        insertInBatches(dummyContacts, 200).then(() => {
          console.log('All records inserted');
        }).catch((err) => {
            console.error('Error:', err);
        });
        
        console.log('All contacts created!');
    } catch (error) {
        console.error('Error:', error);
    }
};

async function loginToSalesforce(username, password) {


  const userInfo = await conn.login(username, password);

  // logged in user property
  console.log("User ID: " + userInfo.id);
  console.log("Org ID: " + userInfo.organizationId);
}

// Call the async function
loginToSalesforce('kamlesh.patel@force.com', 'xyz')
  .then(() => {
    console.log("Login successful");
    createContacts();
    })
  .catch((error) => console.error("Login failed:", error));


  