Feature: Test Calculators: The Modal Charge Calculator on Massmutual.com
  As a user,
  I want to test the Modal Charge Calculator.
###################################
#Application = mm
#Track = calc
#Feature = mcc
##################################

  @mm @mm_calc @mm_calc_mcc @mm_calc_mcc_001
  Scenario Outline: block populate smoke tests
    Given I output "<title>"
    And I am on the "Modal Charge Calculator" calculator page
    When I populate the calculator from "<inputs>" and "Calculate"
    Then the calculator results should match the "base" section of "<inputs>"

    @smoke @xbrowser
    Examples:
      | title                           | inputs                        |
      | Modal Semi-Annual Equal         | ModalSemiAnnualEqual          |
      | Modal Quarterly deficit         | ModalQuarterlyDeficit         |

    Examples:
      | title                           | inputs                        |
      | Modal Quarterly Equal           | ModalQuarterlyEqual           |
      | Modal Quarterly overpayment     | ModalQuarterlyOverpayment     |


  @mm @mm_calc @mm_calc_mcc @mm_calc_mcc_003 @smoke @xbrowser
  Scenario: Verify Disclosure Statement is Accessible on Input Page
    Given I am on the "Modal Charge Calculator" calculator page
    Then I verify the Disclosure Statement text
