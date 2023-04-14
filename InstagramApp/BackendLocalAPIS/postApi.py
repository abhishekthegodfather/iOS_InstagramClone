#  postApi.py
#  InstagramApp
#  Created by Cubastion on 13/04/23.
#  Copyright © 2023 Abhishek Biswas. All rights reserved.

from flask import Flask, jsonify
import json
from typing import List

app = Flask(__name__)

class User:
    def __init__(self, name: str, profileImage: str):
        self.name = name
        self.profileImage = profileImage

class Post:
    def __init__(self, postImage: str, postComment: str, user: User, commentCount: int, likesCount: int, datePosted: str):
        self.postImage = postImage
        self.postComment = postComment
        self.user = user
        self.commentCount = commentCount
        self.likesCount = likesCount
        self.datePosted = datePosted

class Story:
    def __init__(self, post: Post):
        self.post = post

def create_sample_data() -> List[Post]:
    user1 = User(name="John Carmack", profileImage="user1.jpg")
    user2 = User(name="Bjarne Stroustrup", profileImage="user2.jpg")
    post1 = Post(postImage="destination1.jpg", postComment="This is a brilliant destination that I recently went to.", user=user1, commentCount=5, likesCount=10, datePosted="3 Sept")
    post2 = Post(postImage="destination2.jpg", postComment="I am on the wide open road travelling to my new destination.", user=user2, commentCount=14, likesCount=12, datePosted="4 Sept")
    post3 = Post(postImage="destination3.jpg", postComment="Can anyone beat this? This has to be the best sunset ever. I will be coming here again very soon!", user=user1, commentCount=80, likesCount=122, datePosted="5 Sept")
    return [post1, post2, post3]

@app.route('/posts')
def posts():
    sample_posts = create_sample_data()
    posts_json = []
    for post in sample_posts:
        post_dict = {
            'postImage': post.postImage,
            'postComment': post.postComment,
            'user': {
                'name': post.user.name,
                'profileImage': post.user.profileImage,
            },
            'commentCount': post.commentCount,
            'likesCount': post.likesCount,
            'datePosted': post.datePosted,
        }
        posts_json.append(post_dict)
    return jsonify(posts_json)

if __name__ == '__main__':
    app.run()

