// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

List<Opportunity> oppList = new List<Opportunity>();
    Account testAcc = [SELECT Id, Name FROM Account LIMIT 1];
    for (Integer i = 0; i < 200; i++) {
        Opportunity opp = new Opportunity(
            Name = 'Test Opportunity ' + i,
            CloseDate = Date.today(),
            StageName = 'Closed Won',
            AccountId = testAcc.Id,
            Amount = 1000
        );
        oppList.add(opp);
    }
    insert oppList;