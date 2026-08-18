extends Enemy
class_name AstrigianArmsman

var blessedRound = false

func runAI(battleManager: BattleManager):
    var endTurn: bool = false
    if self.rankPosition >= 2:
        endTurn = trySkill(skills[1], battleManager)
        if endTurn:
            print("SWEEPER A: before skills[1] executeSkill")
            await battleManager.executeSkill(self, skills[1], pickTarget(skills[1], battleManager))
            print("SWEEPER A: after skills[1] executeSkill")
    if !endTurn:
        endTurn = trySkill(skills[0], battleManager)
        if endTurn:
            print("SWEEPER B: before skills[0] executeSkill")
            await battleManager.executeSkill(self, skills[0], pickTarget(skills[0], battleManager))
            print("SWEEPER B: after skills[0] executeSkill")
    if !endTurn:
        print("SWEEPER C: before passSkill executeSkill")
        await battleManager.executeSkill(self, passSkill, self)
        print("SWEEPER C: after passSkill executeSkill")
    self.endTurn(battleManager)
        
func targetPriority(characters: Array[Character]) -> Character:
    var lowestCharacter: Character = null
    var lowestValue: int
    var value: int
    if characters == null || characters.size() == 0:
        return null
    for character in characters:
        if lowestCharacter == null:
            lowestCharacter = character
            if character.state == Character.CharacterState.CORPSE:
                lowestValue = character.currHP + 1000
            else:
                lowestValue = character.currHP
        else:
            if character.state == Character.CharacterState.CORPSE:
                value = character.currHP + 1000
            else:
                value = character.currHP
            if value < lowestValue:
                lowestValue = value
                lowestCharacter = character
    return lowestCharacter
