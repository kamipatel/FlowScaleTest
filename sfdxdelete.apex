public class ContactDeletionBatch implements Database.Batchable<SObject> {

    // The prefix to filter contacts by email
    private String prefix;

    // Constructor to initialize the prefix
    public ContactDeletionBatch(String prefix) {
        this.prefix = prefix;
    }

    // Start method to define the scope of records to process
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([SELECT Id FROM Contact WHERE Email LIKE :prefix + '%']);
    }

    // Execute method to perform the deletion
    public void execute(Database.BatchableContext bc, List<Contact> scope) {
        try {
            delete scope;
            System.debug('Successfully deleted ' + scope.size() + ' contacts.');
        } catch (DmlException e) {
            System.debug('An error occurred while deleting contacts: ' + e.getMessage());
        }
    }

    // Finish method for post-processing, if needed
    public void finish(Database.BatchableContext bc) {
        System.debug('Batch process finished.');
    }
}


ContactDeletionBatch batch = new ContactDeletionBatch('flowscaletes');
Database.executeBatch(batch, 30000); // 2000 is the batch size, adjust as needed
