import processing.core.PApplet;

import java.util.ArrayList;
import java.util.List;

/**
 * Author: RaiderRobotics
 * Date: 2015-03-23
 */
class DataInterpreter extends PApplet {
    private LoadingThread currentThread;
    private String fileQuery[];
    private int fileQueryPointer = 0;

    public boolean loaded = false;
    public List<DataNode> list = new ArrayList<DataNode>();

    public DataInterpreter load(String... filePath) {
        fileQuery = filePath;
        return this;
    }

    public DataInterpreter load(String filePath) {
        currentThread = new LoadingThread(this, filePath);
        return this;
    }

    public void tick() {
        if (fileQuery != null && fileQueryPointer < fileQuery.length) {
            load(fileQuery[fileQueryPointer++]);
        } else loaded = currentThread == null || !currentThread.isAlive();
    }

    public class DataNode {
        private final String divider = ",";

        public int index = 0;
        public List<Integer> data = new ArrayList<Integer>();
    }

    class LoadingThread extends Thread {

        LoadingThread(DataInterpreter interpreter, String filePath) {
            int lineNumber = 0; //Keep track of the number of lines

            //Load from file into an array of lines
            for (String line : loadStrings(filePath)) {
                DataNode node = new DataNode();

                //Strip each line by a specific divider ("," by default)
                String args[] = line.split(node.divider);

                //Getting the index
                node.index = Integer.parseInt(args[0], 16); //Second argument is the radix

                //Parse the rest of the data in the line
                for (int i = 1; i < args.length; i++)
                    node.data.add(Integer.parseInt(args[i], 16));

                interpreter.list.add(node);
            }
        }
    }
}