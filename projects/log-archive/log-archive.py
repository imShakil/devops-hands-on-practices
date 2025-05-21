#!/bin/env python3

import os
import sys
import argparse
import zipfile
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.base import MIMEBase
from email import encoders
from datetime import datetime


APP_NAME = 'Log Archiver'
VERSION = '1.0.0' # update verison here


class LogArchiver:

    def __init__(self):
        self.default_output_dir = os.getcwd()
        self.filename = f"log_archives_{datetime.now().strftime('%Y%m%d_%H%M%S')}.zip"
    
    def archive(self, dir, verbose, output_path=None, filename=None):
        """Archive all log files from a directory into a zipfile

        Args:
            dir (string): single directory of all log files 
            output_location (string, optional): an output directory where to save archive file. By defaults it will save in the current directory.
            filename (string, optional): archive file name. default format is: (log_archives_timestamp.zip).
            verbose (boolean, optional)
        """
        if dir is None or not os.path.isdir(dir):
            print("Log directory not found for further processing!")
            return

        if output_path is None:
            output_path = self.default_output_dir
        
        if filename is None:
            filename = self.filename

        os.makedirs(output_path, exist_ok=True)

        archive_path = os.path.join(output_path, filename)

        try:
            with zipfile.ZipFile(archive_path, 'w', zipfile.ZIP_DEFLATED) as zipf:
                for root, _, files in os.walk(dir):
                    for file in files:
                        if verbose: print(f'Scanning file: {file}')
                        if file.endswith('.log'):  # Simple pattern matching
                            file_path = os.path.join(root, file)
                            arcname = os.path.relpath(file_path, start=dir)
                            if verbose: print(f"Added {arcname}")
                            zipf.write(file_path, arcname)
                            
            return archive_path
        except Exception as e:
            raise Exception(f"Failed to create archive: {str(e)}")


class SendMail:

    def __init__(self):
        self.send_from = None
        self.send_to = None
        self.smtp_server = "smtp.gmail.com"
        self.smtp_port = '587'
        self.login_password = None

    def update_email_info(self):
        self.send_from = input("Your gmail account: ").strip()
        self.send_to = input("Send to: ").strip()
        self.login_password = input("App password of your gmail account: ").strip()
    
    def sendmail(self, file):
        msg = MIMEMultipart()
        msg['Subject'] = 'Log Archiver - Check logs'
        msg['To'] = self.send_to
        msg['From'] = self.send_from

        with open(file, 'rb') as f:
            attachment = MIMEBase('application', 'zip')
            attachment.set_payload(f.read())
            encoders.encode_base64(attachment)
            attachment.add_header('Content-Disposition', 
                      f'attachment; filename="{os.path.basename(file)}"')
            msg.attach(attachment)

        try:
            with smtplib.SMTP(self.smtp_server, self.smtp_port) as server:
                if self.smtp_port == 587:
                    server.starttls()
                server.login(self.send_from, self.login_password)
                server.send_message(msg)
            return True
        except Exception as e:
            print(f"\nError sending email: {str(e)}")
            return False


def main():
    parser = argparse.ArgumentParser(
        prog="Log Archiver",
        description="Archive your logs and send it to mail",
        epilog="""\
            Examples:
            Basic usage (creates archive in current directory):
                python log_archiver.py /var/log/myapp
            
            With custom output directory:
                python log_archiver.py /var/log/myapp -o ~/tmp
            
            With custom archive name:
                python log_archiver.py /var/log/myapp -n myapp_logs.zip
        """.strip()
    )

    # required information
    parser.add_argument(
        'log_dir',
        help='full path of your logs to archive'
    )

    # optional
    optional = parser.add_argument_group('archive options')

    optional.add_argument(
        '-n', '--name',
        help='Archive file name, default is: log_archive_timestamp.zip'
    )

    optional.add_argument(
        '-o', '--output',
        help='Path to save the log archive, default is current directory'
    )

    optional.add_argument(
        '-s', '--sendmail',
        action='store_true',
        help='Send it given user email, it will prompt to take mailing info.'
    )

    # mode option (verbose, version)
    mode = parser.add_argument_group('mode')
    mode.add_argument(
        '-v', '--verbose',
        action='store_true',
        help='Choose to see details information'
    )
    
    mode.add_argument(
        '--version',
        action='version',
        version=f'%(prog)s {VERSION}',
        help='Print version'
    )

    # parse argument
    args = parser.parse_args()

    # create an object of LogArchiver
    archiver = LogArchiver()
    mailsender = SendMail()

    try:
        if args.sendmail:
            print("Please update your email info\n")
            mailsender.update_email_info()
        
        if args.verbose:
            print(f"Archiving log files from: {args.log_dir}")
            print(f"Output will be saved at: {args.output if args.output else archiver.default_output_dir}")

        archives = archiver.archive(
            dir=args.log_dir,
            verbose=True if args.verbose else False,
            output_path=args.output,
            filename=args.name
        )

        if args.sendmail:
            print("Preparing logs to send through the mail");
            mailsender.sendmail(archives)
        
        print("Programm executed successfully.")
        print("Thanks for testing my program...\n~imShakil")

    except Exception as e:
        print(f"Archiving is unsuccessfull with following error: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()
