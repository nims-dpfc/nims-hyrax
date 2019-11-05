Feature: Catalog of datasets

  Background:
    Given an initialised sysem with a default admin set, permission template and workflow
    And there is 1 public dataset
    And there are 2 restricted datasets

  Scenario: Unauthenticated user views the dataset catalog
    When I navigate to the dataset index page
    Then I should see the public datasets
    And I should not see the restricted datasets

  Scenario: General user views the dataset catalog
    Given I am logged in as a general user
    And I have permission to view
    When I navigate to the dataset index page
    Then I should see the public and restricted datasets



#  Scenario: General user displays dataset list
#    Given login as a general user
#  5 given data are registered
#    When Open the dataset list screen
#  Then, 5 data are displayed.
#
#  Scenario: Administrator user displays dataset list
#  Log in as a Given administrator
#  5 given data are registered
#    When Open the dataset list screen
#  Then, 5 data are displayed.


#Feature: データセット一覧を参照する
#  現在登録されているユーザを確認するため
#
#  Scenario: 非ログインユーザがデータセット一覧を表示する
#    Given ログインしない
#    Given データが5件登録されている
#    When データセット一覧画面を開く
#    Then データが5件とも表示されない
#
#  Scenario: 一般ユーザがデータセット一覧を表示する
#    Given 一般ユーザでログインする
#    Given データが5件登録されている
#    When データセット一覧画面を開く
#    Then データが5件表示される
#
#  Scenario: 管理者ユーザがデータセット一覧を表示する
#    Given 管理者でログインする
#    Given データが5件登録されている
#    When データセット一覧画面を開く
#    Then データが5件表示される