# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# [START people_quickstart]
from __future__ import print_function
import os.path
from googleapiclient.discovery import build
from google_auth_oauthlib.flow import InstalledAppFlow
from google.auth.transport.requests import Request
from google.oauth2.credentials import Credentials

# If modifying these scopes, delete the file token.json.
SCOPES = ['https://www.googleapis.com/auth/contacts.readonly']


def main():
    """Shows basic usage of the People API.
    Prints the name of the first 10 connections.
    """
    creds = None
    # The file token.json stores the user's access and refresh tokens, and is
    # created automatically when the authorization flow completes for the first
    # time.

    # if file["google_id"]:
    if os.path.exists('token.json'):
        creds = Credentials.from_authorized_user_file('token.json', SCOPES)
    # If there are no (valid) credentials available, let the user log in.
    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            print('Asadasdasd')
            flow = InstalledAppFlow.from_client_secrets_file(
                'client_secret.json', SCOPES)

            kwargs = {}
            kwargs.setdefault("prompt", "consent")
            flow.redirect_uri = flow._OOB_REDIRECT_URI
            auth_url, _ = flow.authorization_url(**kwargs)
            print(auth_url)

            code = input()
            flow.fetch_token(code=code) 

            creds = flow.credentials


            # kwargs = {}
            # kwargs.setdefault("prompt", "consent")

            # auth_url, _ = flow.authorization_url(**kwargs)
            # print(auth_url+"&redirect_uri=http%3A%2F%2Flocalhost%3A27057%2F")

            # creds = flow.run_console()

            # code = input()
            # flow.fetch_token(code=code)
            # creds = flow.credentials
        # Save the credentials for the next run
        with open('token.json', 'w') as token:
            token.write(creds.to_json())

    service = build('people', 'v1', credentials=creds)

    # Call the People API
    print('List 10 connection names')
    results = service.people().connections().list(
        resourceName='people/me',
        pageSize=300,
        personFields='names,emailAddresses,phoneNumbers').execute()
    connections = results.get('connections', [])

    for person in connections:
        names = person.get('names', [])
        if names:
            name = names[0].get('displayName')
            print(name)
        emails = person.get('emailAddresses', [])
        if emails:
            email = emails[0].get('value')
            print(email)
        phones = person.get('phoneNumbers', [])
        if phones:
            phone = phones[0].get('value')
            print(phone)
        print()


if __name__ == '__main__':
    main()
# [END people_quickstart]
