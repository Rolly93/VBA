package com.example.sftpviewerapp;

import com.jcraft.jsch.*;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Vector;

public class SFTPManager {
    private Session session;

    public void connect(String username, String password, String host, int port) throws JSchException {
        JSch jsch = new JSch();
        session = jsch.getSession(username, host, port);
        session.setPassword(password);
        session.setConfig("StrictHostKeyChecking", "no");
        session.connect(10000); // Timeout 10s
    }

    public List<String> listFiles(String path) throws JSchException, SftpException {
        List<String> fileNames = new ArrayList<>();
        Channel channel = session.openChannel("sftp");
        channel.connect();
        ChannelSftp sftp = (ChannelSftp) channel;

        Vector<ChannelSftp.LsEntry> files = sftp.ls(path);
        for (ChannelSftp.LsEntry entry : files) {
            fileNames.add(entry.getFilename());
        }

        sftp.exit();
        return fileNames;
    }

    public InputStream downloadFile(String path) throws Exception {
        Channel channel = session.openChannel("sftp");
        channel.connect();
        ChannelSftp sftp = (ChannelSftp) channel;
        return sftp.get(path);
    }

    public void disconnect() {
        if (session != null && session.isConnected()) {
            session.disconnect();
        }
    }
}
