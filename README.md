# MMP 270 Default Scripts

This is a collection of scripts for a Godot 2D platform/RPG game for use in my MMP 270 course.

To use the scripts, download this repository as a .zip archive from the green Code dropdown, extract the folder and place it in the root directory of the Godot project (it should be in the same folder as project.godot).

Each script has a comment at the top that describes how to use the script, the expected node structure, signals and other setup requirements.

node setup syntax  
• = node that should be created
tab implies hierarchy, parent/child relationships

node example  
• Area2D  
	• AnimatedSprite2D  
	• CollisionShape2D  
	• AudioStreamPlayer2D  

\# is attach script  
• Area2D #Collectible.gd

(ItemName) = **required** item name  
• CharacterBody2D (Player)

(Layer, Mask) = collision layers  
• Area2D (Layer: Collectible, Mask: Player)

(Parameter=true) = set params in inspector  
• Timer (Oneshot=true)  

~ = optional  
• Area2D  
	~ AudioStreamPlayer2D  
*or*  
• Area2D (Layer: Enemy, ~Mask: Player)  


sound effects in scripts are commented out to avoid errors, to introduce sfx, find and uncomment

example, change
```
# remove comment to play sfx
# $JumpSound.play()
```

to 
```
# remove comment to play sfx
$JumpSound.play()
```
