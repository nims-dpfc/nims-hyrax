Feature: Users index page

  Background:
    Given there are 3 general users

  Scenario: Unauthenticated user cannot view users
    When I navigate to the users list
    Then I should not see the general users
    And I should be redirected to the login page

  Scenario: General user cannot view users
    Given I am logged in as an general user
    When I navigate to the users list
    Then I should not see the general users
    And I should be redirected to the home page

  Scenario: Admin user can view users
    Given I am logged in as an admin user
    When I navigate to the users list
    Then I should see the general users

#Feature: ユーザ一覧を参照する
#現在登録されているユーザを確認するため
#
#  Scenario: 非ログインユーザがユーザ一覧を表示する
#    Given ログインしない
#    Given ユーザが5件登録されている
#    When ユーザ一覧画面を開く
#    Then ユーザが5件とも表示されない
#
#  Scenario: 一般ユーザがユーザ一覧を表示する
#    Given 一般ユーザでログインする
#    Given ユーザが5件登録されている
#    When ユーザ一覧画面を開く
#    Then ユーザが5件表示される
#
#  Scenario: 管理者ユーザがユーザ一覧を表示する
#    Given 管理者でログインする
#    Given ユーザが5件登録されている
#    When ユーザ一覧画面を開く
#    Then ユーザが5件表示される
