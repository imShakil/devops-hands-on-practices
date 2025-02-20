import os
import json
from typing import Dict, List
from datetime import datetime
from dotenv import load_dotenv
from bs4 import BeautifulSoup
from medium import Client as MediumClient
from wordpress_api import API as WordPressAPI
from github import Github
from markdown import markdown

class MediumHandler:
    def __init__(self, access_token: str):
        self.client = MediumClient(access_token=access_token)
        self.user = self.client.get_current_user()

    def get_latest_posts(self, limit: int = 5) -> List[Dict]:
        posts = self.client.list_articles(self.user['id'], limit=limit)
        return posts

class WordPressHandler:
    def __init__(self, site_url: str, username: str, password: str):
        self.api = WordPressAPI(
            url=site_url,
            username=username,
            password=password
        )

    def create_post(self, title: str, content: str, status: str = 'publish') -> Dict:
        post_data = {
            'title': title,
            'content': content,
            'status': status,
        }
        return self.api.post('posts', post_data)

class GitHubHandler:
    def __init__(self, access_token: str, repo_name: str):
        self.github = Github(access_token)
        self.repo = self.github.get_user().get_repo(repo_name)

    def create_post(self, title: str, content: str) -> Dict:
        # Convert title to filename-friendly format
        filename = f"_posts/{datetime.now().strftime('%Y-%m-%d')}-{title.lower().replace(' ', '-')}.md"
        
        # Create Jekyll front matter
        front_matter = f"---\ntitle: {title}\ndate: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n---\n\n"
        full_content = front_matter + content

        # Create or update file in repository
        self.repo.create_file(
            path=filename,
            message=f"Add post: {title}",
            content=full_content
        )
        return {"path": filename, "status": "created"}

class CrossPoster:
    def __init__(self):
        load_dotenv()
        
        # Initialize handlers
        self.medium = MediumHandler(os.getenv('MEDIUM_ACCESS_TOKEN'))
        self.wordpress = WordPressHandler(
            os.getenv('WORDPRESS_SITE_URL'),
            os.getenv('WORDPRESS_USERNAME'),
            os.getenv('WORDPRESS_PASSWORD')
        )
        self.github = GitHubHandler(
            os.getenv('GITHUB_ACCESS_TOKEN'),
            os.getenv('GITHUB_REPO_NAME')
        )

    def format_content(self, content: str) -> str:
        # Convert HTML to Markdown for GitHub
        soup = BeautifulSoup(content, 'html.parser')
        
        # Add attribution notice
        attribution = f"\n\n---\n*This article was originally published on [Medium]({content.get('url', '')}).*"
        
        return markdown(str(soup)) + attribution

    def cross_post(self, limit: int = 5):
        # Get latest Medium posts
        posts = self.medium.get_latest_posts(limit)

        for post in posts:
            title = post['title']
            content = post['content']
            formatted_content = self.format_content(content)

            # Post to WordPress
            try:
                wordpress_post = self.wordpress.create_post(title, content)
                print(f"Posted to WordPress: {wordpress_post['link']}")
            except Exception as e:
                print(f"Error posting to WordPress: {str(e)}")

            # Post to GitHub
            try:
                github_post = self.github.create_post(title, formatted_content)
                print(f"Posted to GitHub: {github_post['path']}")
            except Exception as e:
                print(f"Error posting to GitHub: {str(e)}")

def main():
    cross_poster = CrossPoster()
    cross_poster.cross_post()

if __name__ == '__main__':
    main()