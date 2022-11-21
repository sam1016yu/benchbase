import java.sql.*;
import java.io.*;

public class Config {

    //private final static String droplogSQL = "PURGE BINARY LOGS BEFORE NOW();";

    //private final static String url = "jdbc:mysql://10.10.1.1:3306/benchbase?rewriteBatchedStatements=true";

    //private final static String user = "java";

    //private final static String password = "xueyuanren91";

    //Connection conn;

    //PreparedStatement pstmt;

    // public void resetLog() {
    //     try {
    //         System.out.println("Establish Connection for resetLog");
    //         this.conn = DriverManager.getConnection(url, user, password);
    //         Statement stmt = conn.createStatement(); 
    //         stmt.execute(droplogSQL);
    //         System.out.println("delete MySQL binary logs...");
    //         //this.conn.commit();
    //     } catch(SQLException e) {
    //         System.out.println("resetLog: ");
    //         e.printStackTrace(System.out);
    //     }
    // }

    public static void main(String[] args) throws Exception {

        if (args.length < 1) {
            System.out.println("Input parameters: <numTerminals> \n");
            System.exit(0);
        }

        int numTerminals = Integer.parseInt(args[0]);
        String xmltag = "<terminals>";
        String path = "/benchmark/benchbase/target/benchbase-mysql/config/mysql/sample_tpcc_config.xml";
        String newText = "    <terminals>" + numTerminals + "</terminals>";
        
        // delete the mysql binary logs
        //Config obj1 = new Config();
        //obj1.resetLog();

        //read the config file of tpcc benchmark: sample_tpcc_config.xml
        try {
            // input the (modified) file content to the StringBuffer "input"
            BufferedReader file = new BufferedReader(new FileReader(path));
            StringBuffer inputBuffer = new StringBuffer();
            String line;

            while ((line = file.readLine()) != null) {
                if (line.contains(xmltag)) {
                    line = newText;
                    inputBuffer.append(line);
                    inputBuffer.append('\n');
                } else {
                    inputBuffer.append(line);
                    inputBuffer.append('\n');
                }
            }
            file.close();

            // write the new string with the replaced line OVER the same file
            FileOutputStream fileOut = new FileOutputStream(path);
            fileOut.write(inputBuffer.toString().getBytes());
            fileOut.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        System.out.println("Config done: " + numTerminals);
    }
}

